#!/usr/bin/env bash

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Backup function
backup_if_exists() {
    local file=$1
    if [ -f "$file" ] || [ -d "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Backing up existing $file to $backup"
        mv "$file" "$backup"
    fi
}

log_info "Setting up your dev environment..."
log_info "Dotfiles directory: $DOTFILES_DIR"

# --- Install Homebrew ---
if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    log_success "Homebrew installed successfully"
else
    log_success "Homebrew already installed"
fi

# --- Install packages ---
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    log_info "Installing packages from Brewfile..."
    # brew bundle automatically skips already installed packages
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    log_success "Package installation completed"
else
    log_info "No Brewfile found, installing core tools manually..."

    # Install core tools only if not already installed
    for tool in git zsh wget curl neovim eza nvm; do
        if brew list "$tool" &>/dev/null; then
            log_success "$tool already installed"
        else
            log_info "Installing $tool..."
            brew install "$tool"
        fi
    done

    # Install cask applications
    for app in alacritty docker visual-studio-code; do
        if brew list --cask "$app" &>/dev/null; then
            log_success "$app already installed"
        else
            log_info "Installing $app..."
            brew install --cask "$app"
        fi
    done

    log_success "Core tools installation completed"
fi

# --- Install zsh4humans ---
if [ ! -d ~/.cache/zsh4humans ]; then
    log_info "Installing zsh4humans..."
    if command -v curl >/dev/null 2>&1; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
    else
        sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
    fi
    log_success "zsh4humans installed"
else
    log_success "zsh4humans already installed"
fi

# --- Setup NVM ---
if [ -d "$(brew --prefix)/opt/nvm" ]; then
    log_info "Setting up NVM directory..."
    mkdir -p ~/.nvm
    log_success "NVM directory created"
fi

# --- Symlink configuration files ---
log_info "Creating symlinks for configuration files..."

# Create necessary directories
mkdir -p ~/.config/alacritty

# Backup and create symlinks
if [ -f "$DOTFILES_DIR/.logo.txt" ]; then
    backup_if_exists ~/.logo.txt
    ln -sf "$DOTFILES_DIR/.logo.txt" ~/.logo.txt
    log_success "Symlinked .logo.txt"
fi

if [ -f "$DOTFILES_DIR/config/alacritty/alacritty.toml" ]; then
    backup_if_exists ~/.config/alacritty/alacritty.toml
    ln -sf "$DOTFILES_DIR/config/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml
    log_success "Symlinked Alacritty config"
fi

if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    backup_if_exists ~/.zshrc
    ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
    log_success "Symlinked .zshrc"
fi

if [ -f "$DOTFILES_DIR/.p10k.zsh" ]; then
    backup_if_exists ~/.p10k.zsh
    ln -sf "$DOTFILES_DIR/.p10k.zsh" ~/.p10k.zsh
    log_success "Symlinked .p10k.zsh (Powerlevel10k config)"
fi

# --- Set zsh as default shell ---
if [ "$SHELL" != "$(which zsh)" ]; then
    log_info "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
    log_success "Default shell changed to zsh"
else
    log_success "Zsh is already the default shell"
fi

log_success "Setup completed! 🎉"
log_info "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
