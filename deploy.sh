#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$HOME}"

echo "Stowing packages from $DOTFILES_DIR to $TARGET_DIR..."
stow --dir="$DOTFILES_DIR" --target="$TARGET_DIR" bash scripts git
