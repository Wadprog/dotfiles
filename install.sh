bash 

#!/usr/bin/env bash 

echo "Setting up your dev environnement..." 

# --- Install Homebrew --- 
if ! commande -v brew &> /dev/null; then 
  echo "Installing Homebrew..." 
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/ 
fi


# --- Install core tools --- 
brew install git zsh wget curl neovim 
brew install --cask alacritty docker 

# --- Copy configuration files ---
echo "Copying configuration files..." 
mkdir -p ~/.config/alacritty 
cp -r ./config/alacritty/alacritty.toml ~/.config/alacritty/
cp .zshrc ~/ 

chsh -s $(which zsh) 

# --- Optional: set zsh as default shell ---
echo "setup completed" 

