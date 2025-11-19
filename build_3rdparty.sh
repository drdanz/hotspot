#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Error: INSTALL_PREFIX not set"
    exit 1
fi

INSTALL_PREFIX="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CMAKE_ARGS="-DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}"

mkdir -p build-3rdparty
cmake -S 3rdparty/KDDockWidgets/ -B build-3rdparty/KDDockWidgets ${CMAKE_ARGS} -DKDDockWidgets_FRONTENDS=qtwidgets
cmake --build build-3rdparty/KDDockWidgets
cmake --install build-3rdparty/KDDockWidgets

cmake -S 3rdparty/extra-cmake-modules/ -B build-3rdparty/extra-cmake-modules ${CMAKE_ARGS} 
cmake --build build-3rdparty/extra-cmake-modules
cmake --install build-3rdparty/extra-cmake-modules

cmake -S 3rdparty/kcoreaddons/ -B build-3rdparty/kcoreaddons ${CMAKE_ARGS} -DBUILD_PYTHON_BINDINGS=OFF
cmake --build build-3rdparty/kcoreaddons
cmake --install build-3rdparty/kcoreaddons

cmake -S 3rdparty/karchive/ -B build-3rdparty/karchive ${CMAKE_ARGS}
cmake --build build-3rdparty/karchive
cmake --install build-3rdparty/karchive

cmake -S 3rdparty/kitemviews/ -B build-3rdparty/kitemviews ${CMAKE_ARGS}
cmake --build build-3rdparty/kitemviews
cmake --install build-3rdparty/kitemviews

cmake -S 3rdparty/kitemmodels/ -B build-3rdparty/kitemmodels ${CMAKE_ARGS}
cmake --build build-3rdparty/kitemmodels
cmake --install build-3rdparty/kitemmodels

cmake -S 3rdparty/plasma-wayland-protocols/ -B build-3rdparty/plasma-wayland-protocols ${CMAKE_ARGS}
cmake --build build-3rdparty/plasma-wayland-protocols
cmake --install build-3rdparty/plasma-wayland-protocols

cmake -S 3rdparty/kwindowsystem/ -B build-3rdparty/kwindowsystem ${CMAKE_ARGS}
cmake --build build-3rdparty/kwindowsystem
cmake --install build-3rdparty/kwindowsystem

cmake -S 3rdparty/kcrash/ -B build-3rdparty/kcrash ${CMAKE_ARGS}
cmake --build build-3rdparty/kcrash
cmake --install build-3rdparty/kcrash

cmake -S 3rdparty/threadweaver/ -B build-3rdparty/threadweaver ${CMAKE_ARGS}
cmake --build build-3rdparty/threadweaver
cmake --install build-3rdparty/threadweaver

cmake -S 3rdparty/solid/ -B build-3rdparty/solid ${CMAKE_ARGS}
cmake --build build-3rdparty/solid
cmake --install build-3rdparty/solid

cmake -S 3rdparty/syntax-highlighting/ -B build-3rdparty/syntax-highlighting ${CMAKE_ARGS}
cmake --build build-3rdparty/syntax-highlighting
cmake --install build-3rdparty/syntax-highlighting

cmake -S 3rdparty/kcodecs/ -B build-3rdparty/kcodecs ${CMAKE_ARGS}
cmake --build build-3rdparty/kcodecs
cmake --install build-3rdparty/kcodecs

echo "Building kguiaddons..."
cmake -S 3rdparty/kguiaddons/ -B build-3rdparty/kguiaddons ${CMAKE_ARGS} -DBUILD_PYTHON_BINDINGS=OFF
cmake --build build-3rdparty/kguiaddons
cmake --install build-3rdparty/kguiaddons

echo "Building kwidgetsaddons..."
cmake -S 3rdparty/kwidgetsaddons/ -B build-3rdparty/kwidgetsaddons ${CMAKE_ARGS} -DBUILD_PYTHON_BINDINGS=OFF
cmake --build build-3rdparty/kwidgetsaddons
cmake --install build-3rdparty/kwidgetsaddons

echo "Building kconfig..."
cmake -S 3rdparty/kconfig/ -B build-3rdparty/kconfig ${CMAKE_ARGS}
cmake --build build-3rdparty/kconfig
cmake --install build-3rdparty/kconfig

cmake -S 3rdparty/kdbusaddons/ -B build-3rdparty/kdbusaddons ${CMAKE_ARGS}
cmake --build build-3rdparty/kdbusaddons
cmake --install build-3rdparty/kdbusaddons

cmake -S 3rdparty/kcompletion/ -B build-3rdparty/kcompletion ${CMAKE_ARGS}
cmake --build build-3rdparty/kcompletion
cmake --install build-3rdparty/kcompletion

cmake -S 3rdparty/knotifications/ -B build-3rdparty/knotifications ${CMAKE_ARGS} -DBUILD_PYTHON_BINDINGS=OFF
cmake --build build-3rdparty/knotifications
cmake --install build-3rdparty/knotifications

cmake -S 3rdparty/kjobwidgets/ -B build-3rdparty/kjobwidgets ${CMAKE_ARGS} -DBUILD_PYTHON_BINDINGS=OFF
cmake --build build-3rdparty/kjobwidgets
cmake --install build-3rdparty/kjobwidgets

cmake -S 3rdparty/ki18n/ -B build-3rdparty/ki18n ${CMAKE_ARGS}
cmake --build build-3rdparty/ki18n
cmake --install build-3rdparty/ki18n

cmake -S 3rdparty/kauth/ -B build-3rdparty/kauth ${CMAKE_ARGS}
cmake --build build-3rdparty/kauth
cmake --install build-3rdparty/kauth

cmake -S 3rdparty/kcolorscheme/ -B build-3rdparty/kcolorscheme ${CMAKE_ARGS}
cmake --build build-3rdparty/kcolorscheme
cmake --install build-3rdparty/kcolorscheme

cmake -S 3rdparty/kconfigwidgets/ -B build-3rdparty/kconfigwidgets ${CMAKE_ARGS}
cmake --build build-3rdparty/kconfigwidgets
cmake --install build-3rdparty/kconfigwidgets

cmake -S 3rdparty/kiconthemes/ -B build-3rdparty/kiconthemes ${CMAKE_ARGS} -DUSE_BreezeIcons=OFF
cmake --build build-3rdparty/kiconthemes
cmake --install build-3rdparty/kiconthemes

cmake -S 3rdparty/kglobalaccel/ -B build-3rdparty/kglobalaccel ${CMAKE_ARGS}
cmake --build build-3rdparty/kglobalaccel
cmake --install build-3rdparty/kglobalaccel

cmake -S 3rdparty/kxmlgui/ -B build-3rdparty/kxmlgui ${CMAKE_ARGS} -DBUILD_PYTHON_BINDINGS=OFF
cmake --build build-3rdparty/kxmlgui
cmake --install build-3rdparty/kxmlgui

cmake -S 3rdparty/kbookmarks/ -B build-3rdparty/kbookmarks ${CMAKE_ARGS}
cmake --build build-3rdparty/kbookmarks
cmake --install build-3rdparty/kbookmarks

cmake -S 3rdparty/kservice/ -B build-3rdparty/kservice ${CMAKE_ARGS}
cmake --build build-3rdparty/kservice
cmake --install build-3rdparty/kservice

cmake -S 3rdparty/kio/ -B build-3rdparty/kio ${CMAKE_ARGS}
cmake --build build-3rdparty/kio
cmake --install build-3rdparty/kio

cmake -S 3rdparty/kparts/ -B build-3rdparty/kparts ${CMAKE_ARGS}
cmake --build build-3rdparty/kparts
cmake --install build-3rdparty/kparts

cd ${SCRIPT_DIR}/3rdparty/elfutils/
autoreconf -i -f   
./configure --enable-maintainer-mode --enable-libdebuginfod --prefix=${INSTALL_PREFIX}
make -j$(nproc)
make install

cd ${SCRIPT_DIR}/3rdparty/cpuburn
qmake PREFIX=${INSTALL_PREFIX} CONFIG+=release
make -j$(nproc)
make install
