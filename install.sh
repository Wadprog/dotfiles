#!/usr/bin/env bash

. scripts/utils.sh
. scripts/prerequisites.sh
. scripts/brew-install-custom.sh
. scripts/osx-defaults.sh

info "Dotfiles installation initialized..."
read -p "Install apps? [y/n] " install_apps
read -p "Overwrite existing dotfiles? [y/n] " overwrite_dotfiles


if [[ "$install_apps" == "y" ]]; then
    printf "\n"
    info "===================="
    info "Prerequisites"
    info "===================="

    install_xcode
    install_homebrew

    printf "\n"
    info "===================="
    info "App Installation"
    info "===================="

    install_custom_formulae
    install_custom_casks
    run_brew_bundle
fi

printf "\n"
info "===================="
info "OSX System Defaults"
info "===================="

apply_osx_system_defaults

printf "\n"
info "===================="
info "Terminal Setup"
info "===================="

info "Adding .hushlogin to suppress login messages..."
touch ~/.hushlogin

printf "\n"
info "==================="
info "Symbolic Links Setup"
info "==================="

chmod +x ./scripts/symlink.sh
if [[ "$overwrite_dotfiles" == "y" ]]; then
    warning "Overwriting existing dotfiles..."
    ./scripts/symlink.sh --delete --include-files
fi
./scripts/symlink.sh --create

success "Dotfiles installation completed!"