#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Error: INSTALL_PREFIX not set"
    exit 1
fi

INSTALL_PREFIX="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Build elfutils (uses autotools)
cd ${SCRIPT_DIR}/3rdparty/elfutils/
autoreconf -i -f
./configure --enable-maintainer-mode --enable-libdebuginfod --prefix=${INSTALL_PREFIX}
make -j$(nproc)
make install

# Build cpuburn (uses qmake)
cd ${SCRIPT_DIR}/3rdparty/cpuburn
qmake PREFIX=${INSTALL_PREFIX} CONFIG+=release
make -j$(nproc)
make install
