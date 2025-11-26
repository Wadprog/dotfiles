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

install_vscode_extensions() {
    local extensions_file="$SCRIPT_DIR/../vscode/extensions.txt"

    info "Installing VS Code extensions..."

    # Check if extensions file exists
    if [ ! -f "$extensions_file" ]; then
        error "Extensions file not found: $extensions_file"
        return 1
    fi

    # Check if code command is available
    if ! command -v code &> /dev/null; then
        error "VS Code 'code' command not found. Please install VS Code first."
        return 1
    fi

    # Read extensions file and install each extension
    while IFS= read -r extension || [ -n "$extension" ]; do
        # Skip empty lines and comments
        [[ -z "$extension" || "$extension" =~ ^# ]] && continue

        info "Installing extension: $extension"
        code --install-extension "$extension" --force
    done < "$extensions_file"

    success "VS Code extensions installation completed!"
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    setup_vscode_settings
    printf "\n"
    read -p "Install VS Code extensions? [y/n] " install_extensions
    if [[ "$install_extensions" == "y" ]]; then
        install_vscode_extensions
    fi
fi
