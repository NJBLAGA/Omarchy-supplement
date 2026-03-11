#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/NJBLAGA/Dotfiles-V2"
REPO_NAME="Dotfiles"

is_stow_installed() {
  pacman -Qi "stow" &> /dev/null
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
#  echo "removing old configs"
#  rm -rf ~/.config/starship.toml ~/.config/ghostty/config ~/.config/tmux ~/.config/waybar

  cd "$REPO_NAME"
  stow ghostty
  stow starship
  stow tmux
  stow waybar
  stow nvim
  stow bash
else
  echo "Failed to clone the repository."
  exit 1
fi
