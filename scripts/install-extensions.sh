#!/bin/bash

# Script to install VS Code extensions to VS Code and/or Cursor

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/../vscode/extensions.txt"

. "$SCRIPT_DIR/utils.sh"

install_extensions() {
    local cli="$1"
    local editor_name="$2"

    if ! command -v "$cli" &> /dev/null; then
        warning "$editor_name CLI '$cli' not found. Skipping..."
        return 1
    fi

    info "Installing extensions to $editor_name..."

    while IFS= read -r extension || [ -n "$extension" ]; do
        # Skip empty lines and comments
        [[ -z "$extension" || "$extension" == \#* ]] && continue

        if "$cli" --install-extension "$extension" --force &> /dev/null; then
            success "Installed: $extension"
        else
            error "Failed: $extension"
        fi
    done < "$EXTENSIONS_FILE"
}

show_help() {
    echo "Usage: $0 [--code | --cursor | --all | --help]"
    echo ""
    echo "Options:"
    echo "  --code    Install extensions to VS Code only"
    echo "  --cursor  Install extensions to Cursor only"
    echo "  --all     Install extensions to both VS Code and Cursor (default)"
    echo "  --help    Show this help message"
}

# Main
case "${1:---all}" in
    --code)
        install_extensions "code" "VS Code"
        ;;
    --cursor)
        install_extensions "cursor" "Cursor"
        ;;
    --all)
        install_extensions "code" "VS Code"
        echo ""
        install_extensions "cursor" "Cursor"
        ;;
    --help)
        show_help
        ;;
    *)
        error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
