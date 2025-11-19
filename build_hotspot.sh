#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Error: INSTALL_PREFIX not set"
    exit 1
fi

INSTALL_PREFIX="$1"

cmake --preset=release6 -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_BUILT_TYPE=RelWithDebInfo
cmake --build build-release6
cmake --install build-release6
