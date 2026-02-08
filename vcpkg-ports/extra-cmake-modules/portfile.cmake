# Use local source from the git submodule
set(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../3rdparty/extra-cmake-modules")

# Verify source exists
if(NOT EXISTS "${SOURCE_PATH}/CMakeLists.txt")
    message(FATAL_ERROR
        "extra-cmake-modules source not found at ${SOURCE_PATH}. "
        "Please initialize: git submodule update --init 3rdparty/extra-cmake-modules")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DBUILD_HTML_DOCS=OFF
        -DBUILD_MAN_DOCS=OFF
        -DBUILD_QTHELP_DOCS=OFF
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(
    PACKAGE_NAME ECM
    CONFIG_PATH share/ECM/cmake
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING-CMAKE-SCRIPTS")
