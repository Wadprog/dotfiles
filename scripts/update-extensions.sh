#!/bin/bash

# Script to update the VS Code extensions list

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/extensions.txt"

echo "Updating VS Code extensions list..."

# Export current extensions
cat > "$EXTENSIONS_FILE" << 'EOF'
# VS Code Extensions
# This file contains a list of VS Code extensions to be installed
# Install all extensions with: cat extensions.txt | grep -v '^#' | xargs -L 1 code --install-extension

EOF

# Append all installed extensions
code --list-extensions >> "$EXTENSIONS_FILE"

echo "✓ Extensions list updated at: $EXTENSIONS_FILE"
echo "$(code --list-extensions | wc -l | xargs) extensions saved"
