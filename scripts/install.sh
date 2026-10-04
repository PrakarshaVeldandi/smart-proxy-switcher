#!/bin/bash

set -e

# --------------------------------------------------
# Smart Proxy Switcher Installer
# --------------------------------------------------

SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
BASE_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_SCRIPT="$PROJECT_DIR/scripts/toggle-proxy.sh"

BIN_DIR="$HOME/bin"
TARGET_SCRIPT="$BIN_DIR/toggle-proxy.sh"

SHORTCUT_NAME="Smart Proxy Switcher"
SHORTCUT_KEY="F9"

echo "======================================"
echo " Smart Proxy Switcher"
echo " Installation"
echo "======================================"
echo

# --------------------------------------------------
# Check dependencies
# --------------------------------------------------

if ! command -v gsettings >/dev/null 2>&1; then
    echo "Error: gsettings is not available."
    echo "This installer requires GNOME."
    exit 1
fi

if ! command -v notify-send >/dev/null 2>&1; then
    echo "Warning: notify-send is not installed."
    echo "The proxy will still work, but notifications"
    echo "will not be displayed."
    echo
fi

# --------------------------------------------------
# Check proxy script
# --------------------------------------------------

if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo "Error: toggle-proxy.sh was not found."
    echo "Expected:"
    echo "  $SOURCE_SCRIPT"
    exit 1
fi

# --------------------------------------------------
# Install proxy script
# --------------------------------------------------

mkdir -p "$BIN_DIR"

cp "$SOURCE_SCRIPT" "$TARGET_SCRIPT"
chmod +x "$TARGET_SCRIPT"

echo "Proxy script installed:"
echo "  $TARGET_SCRIPT"
echo

# --------------------------------------------------
# Read existing custom shortcuts
# --------------------------------------------------

CURRENT=$(gsettings get "$SCHEMA" custom-keybindings)

echo "Checking existing GNOME shortcuts..."

# --------------------------------------------------
# Find existing Smart Proxy Switcher shortcut
# --------------------------------------------------

EXISTING_PATH=""

for N in {0..99}; do

    SHORTCUT_PATH_CANDIDATE="$BASE_PATH/custom${N}/"

    if [[ "$CURRENT" == *"$SHORTCUT_PATH_CANDIDATE"* ]]; then

        NAME=$(gsettings get \
            "$SCHEMA.custom-keybinding:$SHORTCUT_PATH_CANDIDATE" \
            name 2>/dev/null || true)

        if [[ "$NAME" == "'$SHORTCUT_NAME'" ]]; then
            EXISTING_PATH="$SHORTCUT_PATH_CANDIDATE"
            break
        fi
    fi
done

# --------------------------------------------------
# Check whether F9 is already used
# --------------------------------------------------

F9_PATH=""

for N in {0..99}; do

    SHORTCUT_PATH_CANDIDATE="$BASE_PATH/custom${N}/"

    if [[ "$CURRENT" == *"$SHORTCUT_PATH_CANDIDATE"* ]]; then

        BINDING=$(gsettings get \
            "$SCHEMA.custom-keybinding:$SHORTCUT_PATH_CANDIDATE" \
            binding 2>/dev/null || true)

        if [[ "$BINDING" == "'$SHORTCUT_KEY'" ]]; then
            F9_PATH="$SHORTCUT_PATH_CANDIDATE"
            break
        fi
    fi
done

# --------------------------------------------------
# Existing Smart Proxy Switcher
# --------------------------------------------------

if [ -n "$EXISTING_PATH" ]; then

    echo "Existing Smart Proxy Switcher shortcut found:"
    echo "  $EXISTING_PATH"
    echo

    # F9 belongs to another shortcut
    if [ -n "$F9_PATH" ] && [ "$F9_PATH" != "$EXISTING_PATH" ]; then

        OTHER_NAME=$(gsettings get \
            "$SCHEMA.custom-keybinding:$F9_PATH" \
            name 2>/dev/null || echo "Unknown shortcut")

        echo "Error: F9 is already assigned to:"
        echo "  $OTHER_NAME"
        echo
        echo "The installer will not overwrite it."
        exit 1
    fi

    SHORTCUT_PATH="$EXISTING_PATH"

# --------------------------------------------------
# New installation
# --------------------------------------------------

else

    if [ -n "$F9_PATH" ]; then

        OTHER_NAME=$(gsettings get \
            "$SCHEMA.custom-keybinding:$F9_PATH" \
            name 2>/dev/null || echo "Unknown shortcut")

        echo "Error: F9 is already assigned to:"
        echo "  $OTHER_NAME"
        echo
        echo "The installer will not overwrite it."
        exit 1
    fi

    # Find unused custom shortcut slot
    SHORTCUT_PATH=""

    for N in {0..99}; do

        CANDIDATE="$BASE_PATH/custom${N}/"

        if [[ "$CURRENT" != *"$CANDIDATE"* ]]; then
            SHORTCUT_PATH="$CANDIDATE"
            break
        fi

    done

    if [ -z "$SHORTCUT_PATH" ]; then
        echo "Error: Could not find an available GNOME shortcut slot."
        exit 1
    fi

    echo "Using new GNOME shortcut slot:"
    echo "  $SHORTCUT_PATH"

    # Add new shortcut path
    if [[ "$CURRENT" == "@as []" ]]; then

        NEW_LIST="['$SHORTCUT_PATH']"

    else

        NEW_LIST="${CURRENT%]}"
        NEW_LIST="${NEW_LIST}, '$SHORTCUT_PATH']"

    fi

    gsettings set "$SCHEMA" custom-keybindings "$NEW_LIST"
fi

# --------------------------------------------------
# Configure shortcut
# --------------------------------------------------

gsettings set \
    "$SCHEMA.custom-keybinding:$SHORTCUT_PATH" \
    name "$SHORTCUT_NAME"

gsettings set \
    "$SCHEMA.custom-keybinding:$SHORTCUT_PATH" \
    command "/bin/bash $TARGET_SCRIPT"

gsettings set \
    "$SCHEMA.custom-keybinding:$SHORTCUT_PATH" \
    binding "$SHORTCUT_KEY"

# --------------------------------------------------
# Finished
# --------------------------------------------------

echo
echo "======================================"
echo " Installation complete!"
echo "======================================"
echo
echo "Shortcut : $SHORTCUT_KEY"
echo "Action   : Toggle hostel proxy"
echo
echo "Proxy selection:"
echo "  06:00–23:59 → hostelinternet.rgukt.ac.in:3128"
echo "  00:00–05:59 → staffnet.rgukt.ac.in:3128"
echo
echo "Installed to:"
echo "  $TARGET_SCRIPT"
echo
