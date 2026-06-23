#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing Hyprland overrides..."
bash "$SCRIPT_DIR/install-hyprland-overrides.sh"

echo "==> Installing dotfiles..."
bash "$SCRIPT_DIR/install-dotfiles.sh"

echo "==> Done!"
