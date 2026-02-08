# Use local source from the git submodule
set(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../3rdparty/KDDockWidgets")

# Verify source exists
if(NOT EXISTS "${SOURCE_PATH}/CMakeLists.txt")
    message(FATAL_ERROR
        "KDDockWidgets source not found at ${SOURCE_PATH}. "
        "Please initialize: git submodule update --init 3rdparty/KDDockWidgets")
endif()

# Determine frontends from features
set(FRONTENDS "")
if("qtwidgets" IN_LIST FEATURES)
    list(APPEND FRONTENDS "qtwidgets")
endif()
list(JOIN FRONTENDS ";" FRONTENDS_STRING)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DKDDockWidgets_QT6=ON
        -DKDDockWidgets_FRONTENDS=${FRONTENDS_STRING}
        -DKDDockWidgets_EXAMPLES=OFF
        -DKDDockWidgets_TESTS=OFF
        -DKDDockWidgets_DOCS=OFF
        -DKDDockWidgets_PYTHON_BINDINGS=OFF
        -DKDDockWidgets_DEVELOPER_MODE=OFF
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(
    PACKAGE_NAME KDDockWidgets-qt6
    CONFIG_PATH lib/cmake/KDDockWidgets-qt6
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
