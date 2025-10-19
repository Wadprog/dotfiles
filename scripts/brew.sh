#!/usr/bin/env bash

# Homebrew installation and package management

set -e

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

install_homebrew() {
    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon Macs
        if is_apple_silicon; then
            log_info "Configuring Homebrew for Apple Silicon..."
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        log_success "Homebrew installed successfully"
    else
        log_success "Homebrew already installed"
        log_info "Updating Homebrew..."
        brew update
    fi
}

install_packages() {
    local dotfiles_dir=$1

    log_info "Installing packages..."

    # Install from Brewfile if it exists
    if [ -f "$dotfiles_dir/Brewfile" ]; then
        log_info "Installing packages from Brewfile..."
        brew bundle --file="$dotfiles_dir/Brewfile"
    else
        log_warning "No Brewfile found, installing core packages manually..."

        # Core CLI tools
        brew install git zsh wget curl neovim eza fzf

        # Development tools
        brew install nvm

        # GUI applications
        brew install --cask alacritty docker visual-studio-code
    fi

    log_success "Package installation completed"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    DOTFILES_DIR="${1:-$(dirname "$SCRIPT_DIR")}"
    install_homebrew
    install_packages "$DOTFILES_DIR"
fi
