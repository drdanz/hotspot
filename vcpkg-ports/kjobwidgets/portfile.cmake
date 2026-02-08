set(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../3rdparty/kjobwidgets")

if(NOT EXISTS "${SOURCE_PATH}/CMakeLists.txt")
    message(FATAL_ERROR "kjobwidgets source not found at ${SOURCE_PATH}")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DBUILD_PYTHON_BINDINGS=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME KF6JobWidgets CONFIG_PATH lib/cmake/KF6JobWidgets)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

# Fix missing find_dependency calls for static library LINK_ONLY dependencies
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/KF6JobWidgets/KF6JobWidgetsConfig.cmake"
    "find_dependency(KF6CoreAddons"
    "find_dependency(KF6WidgetsAddons \"6.20.0\")\nfind_dependency(KF6Notifications \"6.20.0\")\nfind_dependency(KF6CoreAddons"
)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSES/LGPL-2.0-or-later.txt")
