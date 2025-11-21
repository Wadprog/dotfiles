#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

setup_vscode_settings() {
    local template_file="$SCRIPT_DIR/../vscode/settings.template.json"
    local output_file="$SCRIPT_DIR/../vscode/settings.json"

    info "Generating VS Code settings.json from template..."

    # Check if template exists
    if [ ! -f "$template_file" ]; then
        error "Template file not found: $template_file"
        return 1
    fi

    # Generate settings.json from template with user-specific paths
    sed "s|{{HOME}}|$HOME|g" "$template_file" > "$output_file"
    success "Generated settings.json (will be symlinked by symlink script)"
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    setup_vscode_settings
fi
