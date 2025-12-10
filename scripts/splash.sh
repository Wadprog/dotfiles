#!/bin/bash
# Terminal splash screen - displays logo with system info
# Uses webvitals color palette

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGO_FILE="$SCRIPT_DIR/../zsh/.logo.txt"

# Webvitals colors
BLUE="\033[38;2;59;130;246m"    # bright_blue #3B82F6
AMBER="\033[38;2;253;150;7m"    # amber #FD9607
RESET="\033[0m"

# Function to get system info
get_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sw_vers -productName 2>/dev/null || echo "macOS"
    else
        uname -s
    fi
}

get_os_version() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sw_vers -productVersion 2>/dev/null
    else
        uname -r
    fi
}

get_uptime() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        boot=$(sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//')
        now=$(date +%s)
        uptime_seconds=$((now - boot))
    else
        uptime_seconds=$(awk '{print int($1)}' /proc/uptime)
    fi

    days=$((uptime_seconds / 86400))
    hours=$(( (uptime_seconds % 86400) / 3600 ))
    minutes=$(( (uptime_seconds % 3600) / 60 ))

    if [ $days -gt 0 ]; then
        echo "${days}d ${hours}h ${minutes}m"
    elif [ $hours -gt 0 ]; then
        echo "${hours}h ${minutes}m"
    else
        echo "${minutes}m"
    fi
}

get_memory() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        total=$(sysctl -n hw.memsize | awk '{print int($1/1024/1024/1024)}')
        used=$(vm_stat | awk '/Pages active/ {active=$3} /Pages wired/ {wired=$4} END {print int((active+wired)*4096/1024/1024/1024)}')
        echo "${used}GB / ${total}GB"
    else
        free -h | awk '/^Mem:/ {print $3 " / " $2}'
    fi
}

get_shell() {
    basename "$SHELL"
}

get_terminal() {
    if [ -n "$TERM_PROGRAM" ]; then
        echo "$TERM_PROGRAM"
    elif [ -n "$WEZTERM_EXECUTABLE" ]; then
        echo "WezTerm"
    else
        echo "$TERM"
    fi
}

# Check if logo file exists
if [ ! -f "$LOGO_FILE" ]; then
    echo -e "${AMBER}Logo file not found: $LOGO_FILE${RESET}"
    exit 1
fi

# Read logo into array (bash 3.x compatible)
logo_lines=()
while IFS= read -r line; do
    logo_lines+=("$line")
done < "$LOGO_FILE"

# Gather system info
os="$(get_os) $(get_os_version)"
host="$(whoami)@$(hostname -s)"
uptime=$(get_uptime)
shell=$(get_shell)
terminal=$(get_terminal)
memory=$(get_memory)

# Create info lines array
info_lines=(
    ""
    ""
    ""
    ""
    ""
    ""
    ""
    ""
    "${BLUE}OS${RESET}       ${AMBER}${os}${RESET}"
    ""
    "${BLUE}Host${RESET}     ${AMBER}${host}${RESET}"
    ""
    "${BLUE}Uptime${RESET}   ${AMBER}${uptime}${RESET}"
    ""
    "${BLUE}Shell${RESET}    ${AMBER}${shell}${RESET}"
    ""
    "${BLUE}Terminal${RESET} ${AMBER}${terminal}${RESET}"
    ""
    "${BLUE}Memory${RESET}   ${AMBER}${memory}${RESET}"
)

# Display logo and info side by side
max_lines=${#logo_lines[@]}
if [ ${#info_lines[@]} -gt $max_lines ]; then
    max_lines=${#info_lines[@]}
fi

for ((i=0; i<max_lines; i++)); do
    # Print logo line
    if [ $i -lt ${#logo_lines[@]} ]; then
        echo -n "${logo_lines[$i]}"
    fi

    # Add spacing between logo and info (3 spaces)
    echo -n "   "

    # Print info line
    if [ $i -lt ${#info_lines[@]} ]; then
        echo -e "${info_lines[$i]}"
    else
        echo ""
    fi
done

echo ""
