# CreateVcpkgOverlay.cmake
#
# Provides two helpers for using system-installed packages with vcpkg:
#   create_vcpkg_overlay_system_package()  - creates an overlay port stub for a system package
#   create_vcpkg_overlay_vcpkg_toolchain() - loads the vcpkg toolchain after overlays are ready
#
# HOW IT WORKS
#
# Normally vcpkg builds all packages from source during the toolchain phase, before
# find_package() can be used.  This module works around that by deferring the vcpkg
# toolchain load until after project() completes (where find_package() works fully).
# The intended usage is via CMAKE_PROJECT_<name>_INCLUDE, which CMake invokes at the
# very end of the named project() call — after compiler detection, but before any
# user code runs.
#
# Execution order:
#   1. project(<name>) is called
#   2. CMake fires CMAKE_PROJECT_<name>_INCLUDE (your setup script)
#   3. find_package() works — detect which system packages are available
#   4. create_vcpkg_overlay_system_package() generates stub overlay port(s)
#   5. create_vcpkg_overlay_vcpkg_toolchain() runs vcpkg.cmake — which sees the overlay and
#      skips building those packages from source
#
# TYPICAL USAGE
#
# In CMakeLists.txt (before project()):
#
#   # If find modules (e.g. FindQt6.cmake) are needed by create_vcpkg_overlay_system_package(),
#   # CMAKE_MODULE_PATH must be set before project() so they are available when the
#   # bootstrap script runs.
#   list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
#   set(CMAKE_PROJECT_<name>_INCLUDE
#       "${CMAKE_CURRENT_SOURCE_DIR}/cmake/vcpkg-bootstrap.cmake")
#   project(<name> ...)
#
# In cmake/vcpkg-bootstrap.cmake:
#
#   include(CreateVcpkgOverlay)
#
#   create_vcpkg_overlay_system_package(
#       CMAKE_MODULE Qt6
#       PORT_NAME    qtbase
#       PORT_DIR     "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/qtbase"
#   )
#   # ... more create_vcpkg_overlay_system_package() calls as needed ...
#
#   create_vcpkg_overlay_vcpkg_toolchain(
#       "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/scripts/buildsystems/vcpkg.cmake"
#   )
#
# CMake 3.19 or later is required.
#
# ---- create_vcpkg_overlay_system_package ----
#
# Creates a vcpkg overlay port for system-installed packages.
# Automatically detects package version and reuses features from a reference vcpkg.json.
#
# SIGNATURE
#   create_vcpkg_overlay_system_package(
#       CMAKE_MODULE <module>
#       PORT_NAME <port>
#       [REQUIRED]
#       [DESCRIPTION <desc>]
#       [OVERLAY_DIR <dir>]
#       [PORT_DIR <dir>]
#   )
#
# PARAMETERS
#   CMAKE_MODULE <module>   - CMake module name to find (e.g., Qt6, Threads)
#   PORT_NAME <port>        - vcpkg port name (e.g., qtbase)
#   VERSION <version>       - Minimum version to pass to find_package (optional)
#   REQUIRED                - Fail with FATAL_ERROR if package not found.
#                             If not set and the package is not found, no overlay is created
#                             and vcpkg will build the port from source as usual.
#   DESCRIPTION <desc>      - Port description (auto-generated if not specified)
#   OVERLAY_DIR <dir>       - Output overlay directory (default: ${CMAKE_BINARY_DIR}/vcpkg-overlay-ports)
#   PORT_DIR <dir>          - Path to the reference port directory containing vcpkg.json
#                             (e.g., 3rdparty/vcpkg/ports/qtbase or vcpkg-ports/qtbase).
#                             If not provided, the overlay is created without features.
#
# EXAMPLES
#   create_vcpkg_overlay_system_package(
#       CMAKE_MODULE Qt6
#       PORT_NAME qtbase
#       REQUIRED
#       PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/qtbase"
#   )
#
#   create_vcpkg_overlay_system_package(
#       CMAKE_MODULE SomeLib
#       PORT_NAME somelib
#       DESCRIPTION "System-provided SomeLib"
#   )

function(create_vcpkg_overlay_system_package)
    cmake_parse_arguments(PKG
        "REQUIRED"
        "CMAKE_MODULE;PORT_NAME;VERSION;DESCRIPTION;OVERLAY_DIR;PORT_DIR"
        ""
        ${ARGN}
    )

    # Validate required parameters
    if(NOT PKG_CMAKE_MODULE)
        message(FATAL_ERROR "create_vcpkg_overlay_system_package: CMAKE_MODULE is required")
    endif()
    if(NOT PKG_PORT_NAME)
        message(FATAL_ERROR "create_vcpkg_overlay_system_package: PORT_NAME is required")
    endif()
    if(VCPKG_TOOLCHAIN)
        message(FATAL_ERROR "create_vcpkg_overlay_system_package: must be called before the vcpkg "
            "toolchain is loaded. The overlay port for '${PKG_PORT_NAME}' would have no effect.")
    endif()
    if(NOT PKG_OVERLAY_DIR)
        set(PKG_OVERLAY_DIR "${CMAKE_BINARY_DIR}/vcpkg-overlay-ports")
    endif()

    # Find the system package (allows both MODULE and CONFIG modes)
    find_package(${PKG_CMAKE_MODULE} ${PKG_VERSION} QUIET)

    if(NOT ${PKG_CMAKE_MODULE}_FOUND)
        if(PKG_REQUIRED)
            message(FATAL_ERROR "create_vcpkg_overlay_system_package: ${PKG_CMAKE_MODULE} package not found (REQUIRED)")
        else()
            # Remove stale overlay directory in case it was created by a previous cmake run
            file(REMOVE_RECURSE "${PKG_OVERLAY_DIR}/${PKG_PORT_NAME}")
            message(STATUS "${PKG_CMAKE_MODULE} not found - overlay port ${PKG_PORT_NAME} not created")
            return()
        endif()
    endif()

    set(PKG_VERSION ${${PKG_CMAKE_MODULE}_VERSION})
    set(PKG_DIR ${${PKG_CMAKE_MODULE}_DIR})

    # Create overlay port directory
    file(MAKE_DIRECTORY "${PKG_OVERLAY_DIR}/${PKG_PORT_NAME}")

    # Set default description
    if(NOT DEFINED PKG_DESCRIPTION)
        set(PKG_DESCRIPTION "${PKG_PORT_NAME} - system installation (version ${PKG_VERSION})")
    endif()

    # Initialize feature arrays
    set(DEFAULT_FEATURES_JSON "[]")
    set(FEATURES_OBJ "{}")
    set(SUPPORTS_LINE "")

    # Read features and supports from reference port directory if provided
    set(_reference_vcpkg_json "")
    if(PKG_PORT_DIR)
        set(_reference_vcpkg_json "${PKG_PORT_DIR}/vcpkg.json")
    endif()

    if(_reference_vcpkg_json AND EXISTS "${_reference_vcpkg_json}")
        file(READ "${_reference_vcpkg_json}" REFERENCE_JSON)

        string(JSON DEFAULT_FEATURES_JSON ERROR_VARIABLE _err GET "${REFERENCE_JSON}" "default-features")
        if(_err)
            set(DEFAULT_FEATURES_JSON "[]")
        endif()

        string(JSON _top_supports ERROR_VARIABLE _err GET "${REFERENCE_JSON}" "supports")
        if(NOT _err)
            set(SUPPORTS_LINE "  \"supports\": \"${_top_supports}\",\n")
        endif()

        # Rebuild features object keeping only description+supports, stripping dependencies
        # (otherwise vcpkg would try to build the feature's library dependencies)
        string(JSON _features_src ERROR_VARIABLE _err GET "${REFERENCE_JSON}" "features")
        if(NOT _err)
            string(JSON _n_features LENGTH "${_features_src}")
            set(FEATURES_OBJ "{}")
            math(EXPR _last "${_n_features} - 1")
            foreach(_i RANGE 0 ${_last})
                string(JSON _fname MEMBER "${_features_src}" ${_i})
                string(JSON _fobj GET "${_features_src}" "${_fname}")
                # Build a minimal feature object with only description (and supports if present)
                string(JSON _fdesc GET "${_fobj}" "description")
                string(JSON _new_fobj SET "{}" "description" "\"${_fdesc}\"")
                string(JSON _fsupports ERROR_VARIABLE _serr GET "${_fobj}" "supports")
                if(NOT _serr)
                    string(JSON _new_fobj SET "${_new_fobj}" "supports" "\"${_fsupports}\"")
                endif()
                string(JSON FEATURES_OBJ SET "${FEATURES_OBJ}" "${_fname}" "${_new_fobj}")
            endforeach()
        endif()
    endif()

    # Generate vcpkg.json with system version but reference features
    file(WRITE "${PKG_OVERLAY_DIR}/${PKG_PORT_NAME}/vcpkg.json"
"{
  \"name\": \"${PKG_PORT_NAME}\",
  \"version\": \"${PKG_VERSION}\",
  \"description\": \"${PKG_DESCRIPTION}\",
${SUPPORTS_LINE}  \"default-features\": ${DEFAULT_FEATURES_JSON},
  \"features\": ${FEATURES_OBJ}
}")

    # Generate minimal portfile.cmake
    file(WRITE "${PKG_OVERLAY_DIR}/${PKG_PORT_NAME}/portfile.cmake"
"set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
set(VCPKG_POLICY_SKIP_MISPLACED_REGULAR_FILES_CHECK enabled)

message(STATUS \"Using system ${PKG_CMAKE_MODULE} ${PKG_VERSION} from: ${PKG_DIR}\")

# Create dummy files to satisfy vcpkg
file(WRITE \"\${CURRENT_PACKAGES_DIR}/share/${PKG_PORT_NAME}/.system-package\" \"System package overlay port for ${PKG_PORT_NAME}\")
file(WRITE \"\${CURRENT_PACKAGES_DIR}/share/${PKG_PORT_NAME}/copyright\" \"\")
")

    # Prepend to VCPKG_OVERLAY_PORTS (so system overlays take precedence),
    # but only if not already present
    if(NOT PKG_OVERLAY_DIR IN_LIST VCPKG_OVERLAY_PORTS)
        if(DEFINED VCPKG_OVERLAY_PORTS)
            set(VCPKG_OVERLAY_PORTS "${PKG_OVERLAY_DIR};${VCPKG_OVERLAY_PORTS}" CACHE STRING "" FORCE)
        else()
            set(VCPKG_OVERLAY_PORTS "${PKG_OVERLAY_DIR}" CACHE STRING "" FORCE)
        endif()
    endif()

    message(STATUS "Created vcpkg overlay for ${PKG_PORT_NAME} (${PKG_VERSION}) at: ${PKG_OVERLAY_DIR}/${PKG_PORT_NAME}")
endfunction()

# ---- create_vcpkg_overlay_vcpkg_toolchain ----
#
# Loads the vcpkg toolchain, chaining any pre-existing user toolchain via
# VCPKG_CHAINLOAD_TOOLCHAIN_FILE.  Must be called AFTER all
# create_vcpkg_overlay_system_package() calls so the overlay ports are ready
# before vcpkg runs its install step.
#
# Implemented as a macro (not a function) so that include() runs in the caller's
# scope: vcpkg.cmake sets CMAKE_PREFIX_PATH and CMAKE_FIND_ROOT_PATH via
# PARENT_SCOPE internally, and those must reach the top-level CMake scope.
#
# SIGNATURE
#   create_vcpkg_overlay_vcpkg_toolchain(<vcpkg_toolchain_file>)
#
# PARAMETERS
#   <vcpkg_toolchain_file>  - Absolute path to vcpkg.cmake
#                             (e.g. "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/scripts/buildsystems/vcpkg.cmake")
#
# EXAMPLE
#   create_vcpkg_overlay_vcpkg_toolchain("${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/scripts/buildsystems/vcpkg.cmake")

macro(create_vcpkg_overlay_vcpkg_toolchain _vcpkg_toolchain_file)
    # If the user provided their own toolchain (e.g. for cross-compilation), save it.
    # It was already processed by CMake during project(), so we must not re-include it
    # here; it is chained for try_compile sub-processes via VCPKG_CHAINLOAD_TOOLCHAIN_FILE.
    set(_vcpkg_it_user_toolchain "")
    if(DEFINED CMAKE_TOOLCHAIN_FILE AND NOT CMAKE_TOOLCHAIN_FILE STREQUAL "")
        set(_vcpkg_it_user_toolchain "${CMAKE_TOOLCHAIN_FILE}")
    endif()

    # Include the vcpkg toolchain so packages are built/installed and
    # CMAKE_TOOLCHAIN_FILE is set (with CACHE+FORCE by vcpkg.cmake itself) so it
    # propagates to try_compile sub-processes automatically.
    include("${_vcpkg_toolchain_file}")

    # Chain the user's original toolchain for try_compile sub-processes only.
    if(_vcpkg_it_user_toolchain)
        set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${_vcpkg_it_user_toolchain}")
    endif()

    unset(_vcpkg_it_user_toolchain)
    unset(_vcpkg_toolchain_file)
endmacro()
