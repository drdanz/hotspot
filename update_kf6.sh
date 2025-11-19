#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <branch>"
    echo "Example: $0 master"
    exit 1
fi

BRANCH="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THIRDPARTY_DIR="$SCRIPT_DIR/3rdparty"

# KDE submodules to update
KDE_MODULES=(
    extra-cmake-modules
    karchive
    kauth
    kbookmarks
    kcodecs
    kcolorscheme
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    kglobalaccel
    kguiaddons
    ki18n
    kiconthemes
    kio
    kitemmodels
    kitemviews
    kjobwidgets
    knotifications
    kparts
    kservice
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    solid
    syntax-highlighting
    threadweaver
)

# plasma-wayland-protocols has its own versioning

for module in "${KDE_MODULES[@]}"; do
    module_path="$THIRDPARTY_DIR/$module"
    if [ -d "$module_path" ]; then
        echo "Updating $module..."
        cd "$module_path"
        git fetch
        git checkout "$BRANCH"
    else
        echo "Warning: $module not found at $module_path"
    fi
done

echo "Done updating KDE modules to branch: $BRANCH"
