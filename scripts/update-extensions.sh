#!/bin/bash

# Script to update the VS Code/Cursor extensions list

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/../vscode/extensions.txt"

. "$SCRIPT_DIR/utils.sh"

update_extensions() {
    local cli="$1"
    local editor_name="$2"

    if ! command -v "$cli" &> /dev/null; then
        error "$editor_name CLI '$cli' not found."
        exit 1
    fi

    info "Updating extensions list from $editor_name..."

    # Export current extensions
    cat > "$EXTENSIONS_FILE" << 'EOF'
# VS Code Extensions
# This file contains a list of VS Code extensions to be installed
# Install all extensions with: ./scripts/install-extensions.sh --all

EOF

    # Append all installed extensions
    "$cli" --list-extensions >> "$EXTENSIONS_FILE"

    success "Extensions list updated at: $EXTENSIONS_FILE"
    echo "$("$cli" --list-extensions | wc -l | xargs) extensions saved"
}

show_help() {
    echo "Usage: $0 [--code | --cursor | --help]"
    echo ""
    echo "Options:"
    echo "  --code    Export extensions from VS Code (default)"
    echo "  --cursor  Export extensions from Cursor"
    echo "  --help    Show this help message"
}

# Main
case "${1:---code}" in
    --code)
        update_extensions "code" "VS Code"
        ;;
    --cursor)
        update_extensions "cursor" "Cursor"
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
