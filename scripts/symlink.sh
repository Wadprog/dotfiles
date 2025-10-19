#!/usr/bin/env bash

# Create symlinks for dotfiles

set -e

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

create_symlinks() {
    local dotfiles_dir=$1

    log_info "Creating symlinks for configuration files..."

    # Create necessary directories
    mkdir -p ~/.config/alacritty
    mkdir -p ~/.config/nvim

    # Symlink .zshrc
    if [ -f "$dotfiles_dir/.zshrc" ]; then
        backup_if_exists ~/.zshrc
        ln -sf "$dotfiles_dir/.zshrc" ~/.zshrc
        log_success "Linked .zshrc"
    fi

    # Symlink logo
    if [ -f "$dotfiles_dir/.logo.txt" ]; then
        backup_if_exists ~/.logo.txt
        ln -sf "$dotfiles_dir/.logo.txt" ~/.logo.txt
        log_success "Linked .logo.txt"
    fi

    # Symlink Alacritty config
    if [ -f "$dotfiles_dir/config/alacritty/alacritty.toml" ]; then
        backup_if_exists ~/.config/alacritty/alacritty.toml
        ln -sf "$dotfiles_dir/config/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml
        log_success "Linked Alacritty config"
    fi

    # Symlink Git config if it exists
    if [ -f "$dotfiles_dir/.gitconfig" ]; then
        backup_if_exists ~/.gitconfig
        ln -sf "$dotfiles_dir/.gitconfig" ~/.gitconfig
        log_success "Linked .gitconfig"
    fi

    log_success "Symlinks created successfully"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    DOTFILES_DIR="${1:-$(dirname "$SCRIPT_DIR")}"
    create_symlinks "$DOTFILES_DIR"
fi
