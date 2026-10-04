#!/bin/bash

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT_PATH="$PROJECT_DIR/scripts/toggle-proxy.sh"

BIN_DIR="$HOME/bin"
TARGET="$BIN_DIR/toggle-proxy.sh"

SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
CUSTOM_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"

echo "======================================"
echo " Smart Proxy Switcher Installation"
echo "======================================"
echo

# Create ~/bin
mkdir -p "$BIN_DIR"

# Install the proxy script
cp "$SCRIPT_PATH" "$TARGET"
chmod +x "$TARGET"

echo "Installed proxy script:"
echo "  $TARGET"
echo

# Get current custom shortcuts
CURRENT=$(gsettings get "$SCHEMA" custom-keybindings)

# Add custom1 if it doesn't exist
if [[ "$CURRENT" != *"$CUSTOM_PATH"* ]]; then

    if [[ "$CURRENT" == "@as []" ]]; then
        NEW_LIST="['$CUSTOM_PATH']"
    else
        NEW_LIST="${CURRENT%]}"
        NEW_LIST="${NEW_LIST}, '$CUSTOM_PATH']"
    fi

    gsettings set "$SCHEMA" custom-keybindings "$NEW_LIST"
fi

# Configure custom1
gsettings set \
    "$SCHEMA.custom-keybinding:$CUSTOM_PATH" \
    name "Smart Proxy Switcher"

gsettings set \
    "$SCHEMA.custom-keybinding:$CUSTOM_PATH" \
    command "/bin/bash $TARGET"

gsettings set \
    "$SCHEMA.custom-keybinding:$CUSTOM_PATH" \
    binding "F9"

echo
echo "Installation complete!"
echo
echo "Shortcut : F9"
echo "Action   : Toggle hostel proxy"
echo
echo "The proxy host is selected automatically:"
echo "  06:00–23:59 → hostelinternet.rgukt.ac.in:3128"
echo "  00:00–05:59 → staffnet.rgukt.ac.in:3128"
echo
