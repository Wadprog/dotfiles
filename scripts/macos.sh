#!/usr/bin/env bash

# macOS system preferences configuration
# Based on https://mths.be/macos

set -e

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

configure_macos() {
    if ! is_macos; then
        log_warning "Not running on macOS, skipping system preferences configuration"
        return
    fi

    log_info "Configuring macOS system preferences..."

    # Ask for the administrator password upfront
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until script has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    ###############################################################################
    # General UI/UX                                                               #
    ###############################################################################

    log_info "Setting UI/UX preferences..."

    # Disable the sound effects on boot
    # sudo nvram SystemAudioVolume=" "

    # Expand save panel by default
    # defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    # defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Save to disk (not to iCloud) by default
    # defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

    ###############################################################################
    # Trackpad, mouse, keyboard                                                  #
    ###############################################################################

    log_info "Setting input device preferences..."

    # Trackpad: enable tap to click for this user and for the login screen
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Enable full keyboard access for all controls
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # Set fast keyboard repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    ###############################################################################
    # Finder                                                                      #
    ###############################################################################

    log_info "Setting Finder preferences..."

    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Show status bar
    defaults write com.apple.finder ShowStatusBar -bool true

    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Display full POSIX path as Finder window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Use list view in all Finder windows by default
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Show the ~/Library folder
    chflags nohidden ~/Library

    ###############################################################################
    # Dock                                                                        #
    ###############################################################################

    log_info "Setting Dock preferences..."

    # Set the icon size of Dock items
    defaults write com.apple.dock tilesize -int 50

    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool true

    # Remove the auto-hiding Dock delay
    defaults write com.apple.dock autohide-delay -float 0

    # Don't show recent applications in Dock
    defaults write com.apple.dock show-recents -bool false

    ###############################################################################
    # Terminal                                                                    #
    ###############################################################################

    log_info "Setting Terminal preferences..."

    # Only use UTF-8 in Terminal.app
    defaults write com.apple.terminal StringEncodings -array 4

    ###############################################################################
    # Activity Monitor                                                            #
    ###############################################################################

    # Show the main window when launching Activity Monitor
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

    # Show all processes in Activity Monitor
    defaults write com.apple.ActivityMonitor ShowCategory -int 0

    ###############################################################################
    # Kill affected applications                                                  #
    ###############################################################################

    log_info "Restarting affected applications..."

    for app in "Dock" "Finder"; do
        killall "${app}" &> /dev/null || true
    done

    log_success "macOS configuration completed"
    log_warning "Note: Some changes require logout/restart to take effect"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_macos
fi
