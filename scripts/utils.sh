#!/usr/bin/env bash

# Utility functions for dotfiles installation

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export NC='\033[0m' # No Color

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

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if running on macOS
is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
}

# Check if Apple Silicon Mac
is_apple_silicon() {
    [[ $(uname -m) == 'arm64' ]]
}
