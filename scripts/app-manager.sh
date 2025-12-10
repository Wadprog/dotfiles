#!/bin/bash
# Periodically Check App Listed in BrewFile and report installation status
# Detects apps installed via brew, cask, or manually in Applications

DIR=$(cd "$(dirname "$0")" && pwd)
BREWFILE="$(cd "$DIR/.." && pwd)/homebrew/Brewfile"

# Load installed packages separately for formulae and casks
# Convert newlines to spaces for pattern matching
INSTALLED_FORMULAE=$(brew list --formula 2>/dev/null | tr '\n' ' ' || echo "")
INSTALLED_CASKS=$(brew list --cask 2>/dev/null | tr '\n' ' ' || echo "")

# Check if a formula is installed via brew
is_formula_installed() {
    local package="$1"
    [[ " $INSTALLED_FORMULAE " =~ " $package " ]]
}

# Check if a cask is installed via brew
is_cask_installed() {
    local package="$1"
    [[ " $INSTALLED_CASKS " =~ " $package " ]]
}

# Bash 3.x compatible capitalize function
capitalize() {
    local str="$1"
    echo "$(echo "${str:0:1}" | tr '[:lower:]' '[:upper:]')${str:1}"
}

# Bash 3.x compatible uppercase function
uppercase() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Generate possible app name variations from package name
generate_app_name_variations() {
    local package="$1"
    local variations=()

    # Variation 1: Exact package name
    variations+=("$package")

    # Variation 2: Capitalize first letter
    variations+=("$(capitalize "$package")")

    # Variation 3: Replace hyphens with spaces and title case each word
    local space_separated="${package//-/ }"
    local title_cased=""
    for word in $space_separated; do
        title_cased+="$(capitalize "$word") "
    done
    title_cased="${title_cased% }"  # Remove trailing space
    variations+=("$title_cased")

    # Variation 4: Replace hyphens and numbers with spaces
    # e.g., "pgadmin4" -> "pgadmin 4"
    local with_space_before_num=$(echo "$package" | sed 's/\([a-z]\)\([0-9]\)/\1 \2/g')
    variations+=("$with_space_before_num")

    # Variation 5: Title case with space before numbers
    local title_with_num=""
    for word in $with_space_before_num; do
        title_with_num+="$(capitalize "$word") "
    done
    title_with_num="${title_with_num% }"
    variations+=("$title_with_num")

    # Variation 6: All uppercase (for acronyms)
    variations+=("$(uppercase "$package")")

    # Variation 7: PascalCase (remove hyphens and capitalize each word)
    local pascal_case=""
    for word in $space_separated; do
        pascal_case+="$(capitalize "$word")"
    done
    variations+=("$pascal_case")

    # Return unique variations
    printf '%s\n' "${variations[@]}" | sort -u
}

# Check if app exists in Applications directories
is_installed_in_app_dir() {
    local package="$1"

    # Generate all possible app name variations
    local variations=($(generate_app_name_variations "$package"))

    # Check both /Applications and ~/Applications
    local app_dirs=(
        "/Applications"
        "$HOME/Applications"
    )

    for dir in "${app_dirs[@]}"; do
        for name in "${variations[@]}"; do
            if [ -d "$dir/${name}.app" ]; then
                echo "$dir/${name}.app"
                return 0
            fi
        done
    done

    return 1
}

# Main check function that tries all detection methods
is_app_installed() {
    local package="$1"
    local type="$2"  # "formula" or "cask"

    # Check if managed by brew/cask first
    if [[ "$type" == "formula" ]]; then
        if is_formula_installed "$package"; then
            echo "✓ $package is installed (via brew formula)"
            return 0
        fi
    elif [[ "$type" == "cask" ]]; then
        if is_cask_installed "$package"; then
            echo "✓ $package is installed (via brew cask)"
            return 0
        fi
    fi

    # Fallback: check if app exists in Applications directory
    local app_path=$(is_installed_in_app_dir "$package")
    if [ $? -eq 0 ]; then
        echo "✓ $package is installed (found at: $app_path, not managed by brew)"
        return 0
    fi

    echo "✗ $package is NOT installed"
    return 1
}

# Read and process Brewfile
read_brewfile() {
    if [ ! -f "$BREWFILE" ]; then
        echo "Error: Brewfile not found at $BREWFILE"
        exit 1
    fi

    echo "Reading from: $BREWFILE"
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo ""

    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$line" ]] && continue
        [[ "$line" =~ ^tap ]] && continue

        # Remove inline comments
        line="${line%%#*}"

        # Extract package name and remove quotes
        package=$(echo "$line" | awk '{print $2}' | tr -d '"')

        # Skip if no package name extracted
        [ -z "$package" ] && continue

        # Determine package type
        local type=""
        if [[ "$line" =~ ^brew ]]; then
            type="formula"
        elif [[ "$line" =~ ^cask ]]; then
            type="cask"
        else
            continue  # Skip if neither brew nor cask
        fi

        # Check installation status
        echo "Checking $type: $package"
        is_app_installed "$package" "$type"
        echo ""
    done < "$BREWFILE"

    echo "═══════════════════════════════════════════════════════════"
}

# Run the check
read_brewfile
