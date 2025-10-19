#!/usr/bin/env bash

# Script to verify that dotfiles are properly symlinked

echo "Checking symlink status..."
echo ""

check_symlink() {
    local target=$1
    local expected_source=$2

    if [ -L "$target" ]; then
        actual_source=$(readlink "$target")
        if [ "$actual_source" = "$expected_source" ]; then
            echo "✓ $target → $actual_source"
        else
            echo "⚠ $target points to $actual_source (expected $expected_source)"
        fi
    elif [ -f "$target" ]; then
        echo "✗ $target exists but is NOT a symlink (it's a regular file)"
    else
        echo "✗ $target does not exist"
    fi
}

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

check_symlink ~/.zshrc "$DOTFILES_DIR/.zshrc"
check_symlink ~/.p10k.zsh "$DOTFILES_DIR/.p10k.zsh"
check_symlink ~/.logo.txt "$DOTFILES_DIR/.logo.txt"
check_symlink ~/.config/alacritty/alacritty.toml "$DOTFILES_DIR/config/alacritty/alacritty.toml"

echo ""
echo "To manually create symlinks, run: ./install.sh"
