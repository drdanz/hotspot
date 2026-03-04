include(CreateVcpkgOverlay)

create_vcpkg_overlay_system_package(
    CMAKE_MODULE Qt6
    PORT_NAME qtbase
    DESCRIPTION "Qt Base - system Qt6 installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/qtbase"
)

# create_vcpkg_overlay_system_package(
#     CMAKE_MODULE Qt6WaylandClient
#     PORT_NAME qtwayland
#     DESCRIPTION "Qt Wayland - system Qt6 installation"
#     PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/qtwayland"
# )

create_vcpkg_overlay_system_package(
    CMAKE_MODULE Qt6Svg
    PORT_NAME qtsvg
    DESCRIPTION "Qt SVG - system Qt6 installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/qtsvg"
)

create_vcpkg_overlay_system_package(
    CMAKE_MODULE Qt6Qml
    PORT_NAME qtdeclarative
    DESCRIPTION "Qt Declarative (QML) - system Qt6 installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/qtdeclarative"
)

create_vcpkg_overlay_system_package(
    CMAKE_MODULE Gettext
    PORT_NAME gettext
    DESCRIPTION "gettext - system installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/gettext"
)

# create_vcpkg_overlay_system_package(
#     CMAKE_MODULE Intl
#     PORT_NAME gettext-libintl
#     DESCRIPTION "gettext libintl - system installation"
#     PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/gettext-libintl"
# )

create_vcpkg_overlay_system_package(
    CMAKE_MODULE LibMount
    PORT_NAME libmount
    DESCRIPTION "libmount - system installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/libmount"
)

create_vcpkg_overlay_system_package(
    CMAKE_MODULE ZLIB
    PORT_NAME zlib
    DESCRIPTION "zlib - system installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/zlib"
)

create_vcpkg_overlay_system_package(
    CMAKE_MODULE LibXml2
    PORT_NAME libxml2
    DESCRIPTION "libxml2 - system installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/libxml2"
)

create_vcpkg_overlay_system_package(
    CMAKE_MODULE LibXslt
    PORT_NAME libxslt
    DESCRIPTION "libxslt - system installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/libxslt"
)

create_vcpkg_overlay_system_package(
    CMAKE_MODULE Canberra
    PORT_NAME libcanberra
    DESCRIPTION "libcanberra - system installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/libcanberra"
)

create_vcpkg_overlay_system_package(
    CMAKE_MODULE Qt6Tools
    PORT_NAME qttools
    DESCRIPTION "Qt Tools - system Qt6 installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/qttools"
)

create_vcpkg_overlay_system_package(
    CMAKE_MODULE LibLZMA
    PORT_NAME liblzma
    DESCRIPTION "liblzma - system installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/liblzma"
)

create_vcpkg_overlay_system_package(
    CMAKE_MODULE nlohmann_json
    PORT_NAME nlohmann-json
    DESCRIPTION "nlohmann-json - system installation"
    PORT_DIR "${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/ports/nlohmann-json"
)

create_vcpkg_overlay_vcpkg_toolchain("${CMAKE_SOURCE_DIR}/3rdparty/vcpkg/scripts/buildsystems/vcpkg.cmake")
