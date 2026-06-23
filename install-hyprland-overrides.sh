#!/bin/bash

set -e

HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.conf"
HYPRIDLE_CONFIG="$HOME/.config/hypr/hypridle.conf"
MIMEAPPS_CONFIG="$HOME/.config/mimeapps.list"
APPLICATIONS_DIR="$HOME/.local/share/applications"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVERRIDES_CONFIG="$SCRIPT_DIR/hyprland-overrides.conf"
HYPRIDLE_SOURCE="$SCRIPT_DIR/hypridle.conf"
GMAIL_DESKTOP_SOURCE="$SCRIPT_DIR/gmail.desktop"
SOURCE_LINE="source = $OVERRIDES_CONFIG"

# --- hyprland-overrides.conf ---

if [ ! -f "$HYPRLAND_CONFIG" ]; then
    echo "Hyprland config not found at $HYPRLAND_CONFIG"
    echo "Please install hyprland first"
    exit 1
fi

if [ ! -f "$OVERRIDES_CONFIG" ]; then
    echo "Overrides config not found at $OVERRIDES_CONFIG"
    exit 1
fi

if grep -Fxq "$SOURCE_LINE" "$HYPRLAND_CONFIG"; then
    echo "Source line already exists in $HYPRLAND_CONFIG"
else
    echo "Adding source line to $HYPRLAND_CONFIG"
    echo "" >> "$HYPRLAND_CONFIG"
    echo "$SOURCE_LINE" >> "$HYPRLAND_CONFIG"
    echo "Source line added successfully"
fi

# --- hypridle.conf symlink ---

if [ ! -f "$HYPRIDLE_SOURCE" ]; then
    echo "hypridle.conf not found at $HYPRIDLE_SOURCE"
    exit 1
fi

if [ -L "$HYPRIDLE_CONFIG" ]; then
    echo "hypridle.conf symlink already exists at $HYPRIDLE_CONFIG"
elif [ -f "$HYPRIDLE_CONFIG" ]; then
    echo "Backing up existing hypridle.conf to $HYPRIDLE_CONFIG.bak"
    mv "$HYPRIDLE_CONFIG" "$HYPRIDLE_CONFIG.bak"
    ln -s "$HYPRIDLE_SOURCE" "$HYPRIDLE_CONFIG"
    echo "Symlink created: $HYPRIDLE_CONFIG -> $HYPRIDLE_SOURCE"
else
    ln -s "$HYPRIDLE_SOURCE" "$HYPRIDLE_CONFIG"
    echo "Symlink created: $HYPRIDLE_CONFIG -> $HYPRIDLE_SOURCE"
fi

# --- gmail.desktop ---

mkdir -p "$APPLICATIONS_DIR"

if [ -L "$APPLICATIONS_DIR/gmail.desktop" ]; then
    echo "gmail.desktop symlink already exists"
elif [ -f "$APPLICATIONS_DIR/gmail.desktop" ]; then
    echo "Backing up existing gmail.desktop"
    mv "$APPLICATIONS_DIR/gmail.desktop" "$APPLICATIONS_DIR/gmail.desktop.bak"
    ln -s "$GMAIL_DESKTOP_SOURCE" "$APPLICATIONS_DIR/gmail.desktop"
    echo "Symlink created: $APPLICATIONS_DIR/gmail.desktop -> $GMAIL_DESKTOP_SOURCE"
else
    ln -s "$GMAIL_DESKTOP_SOURCE" "$APPLICATIONS_DIR/gmail.desktop"
    echo "Symlink created: $APPLICATIONS_DIR/gmail.desktop -> $GMAIL_DESKTOP_SOURCE"
fi

# --- mimeapps.list mailto override ---

MAILTO_LINE="x-scheme-handler/mailto=gmail.desktop"

if [ ! -f "$MIMEAPPS_CONFIG" ]; then
    echo "[Default Applications]" > "$MIMEAPPS_CONFIG"
    echo "$MAILTO_LINE" >> "$MIMEAPPS_CONFIG"
    echo "Created $MIMEAPPS_CONFIG with Gmail mailto handler"
elif grep -q "^x-scheme-handler/mailto=" "$MIMEAPPS_CONFIG"; then
    sed -i "s|^x-scheme-handler/mailto=.*|$MAILTO_LINE|" "$MIMEAPPS_CONFIG"
    echo "Updated mailto handler to Gmail in $MIMEAPPS_CONFIG"
else
    echo "$MAILTO_LINE" >> "$MIMEAPPS_CONFIG"
    echo "Added Gmail mailto handler to $MIMEAPPS_CONFIG"
fi

echo "Hyprland overrides setup complete!"
