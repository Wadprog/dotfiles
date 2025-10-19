# Dotfiles

Personal macOS development environment configuration files and setup scripts.

## Features

- **Automated Setup**: One-command installation for a fresh Mac
- **Package Management**: Homebrew with Brewfile for reproducible installs
- **Terminal**: Alacritty with custom configuration
- **Shell**: Zsh with zsh4humans framework for better UX
- **Modular Scripts**: Organized installation scripts for easy maintenance
- **Safe Installation**: Automatic backups of existing configurations

## Quick Start

### Fresh Installation

On a fresh Mac, run:

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The script will:
1. Install Homebrew (if not present)
2. Install all packages from Brewfile
3. Install zsh4humans
4. Create backups of existing configs
5. **Symlink** configurations (not copy - changes sync automatically!)
6. Set zsh as default shell

### How Symlinks Work

This dotfiles setup uses **symbolic links (symlinks)** instead of copying files. This means:

- `~/.zshrc` → points to `~/.dotfiles/.zshrc`
- `~/.p10k.zsh` → points to `~/.dotfiles/.p10k.zsh`
- `~/.logo.txt` → points to `~/.dotfiles/.logo.txt`
- `~/.config/alacritty/alacritty.toml` → points to `~/.dotfiles/config/alacritty/alacritty.toml`

**Benefits:**
- Edit any config file and changes are automatically in your git repo
- Keep your dotfiles in sync across machines
- No need to manually copy files back and forth
- Your Powerlevel10k customizations are portable!

**Important:** When you edit these files, you're actually editing the files in your dotfiles repo. Don't forget to commit and push your changes!

### What Gets Installed

**CLI Tools:**
- git, zsh, neovim, wget, curl
- eza (modern ls replacement)
- fzf (fuzzy finder)
- bat (better cat)
- ripgrep, fd (fast search tools)
- nvm (Node version manager)
- docker, docker-compose

**Applications:**
- Alacritty (terminal emulator)
- Visual Studio Code
- Docker Desktop

**Fonts:**
- MesloLGS Nerd Font

## File Structure

```
dotfiles/
├── install.sh              # Main installation script
├── Brewfile               # Homebrew packages
├── .zshrc                 # Zsh configuration
├── .p10k.zsh              # Powerlevel10k theme configuration
├── .logo.txt              # Terminal startup logo
├── config/
│   └── alacritty/
│       └── alacritty.toml # Alacritty terminal config
└── scripts/
    ├── utils.sh           # Utility functions
    ├── brew.sh            # Homebrew setup
    ├── symlink.sh         # Symlink configurations
    └── macos.sh           # macOS system preferences (optional)
```

## Configuration Files

### Zsh (.zshrc)

Using zsh4humans framework which provides:
- Fast startup time
- Command auto-suggestions
- Syntax highlighting
- Fuzzy file completion with fzf
- Git integration
- **Powerlevel10k theme** (pre-configured)

Custom additions:
- NVM integration
- Eza aliases for better file listing
- Useful functions (e.g., `md` to mkdir and cd)

### Powerlevel10k (.p10k.zsh)

Powerlevel10k is a fast and customizable prompt theme included with zsh4humans.

Your custom configuration is saved in `.p10k.zsh`. To reconfigure your prompt:
```bash
p10k configure
```

The symlinked file means your prompt settings are version-controlled and portable across machines!

### Alacritty

Custom terminal configuration featuring:
- 70% opacity with blur effect
- Custom blue/orange color scheme
- MesloLGS Nerd Font
- Optimized padding and appearance

## Optional: macOS System Preferences

To configure macOS system preferences (UI/UX, Finder, Dock, etc.), run:

```bash
./scripts/macos.sh
```

This will configure settings like:
- Fast keyboard repeat rate
- Show all file extensions in Finder
- Auto-hide Dock
- Enable tap-to-click
- And more...

**Note:** Some changes require logout/restart to take effect.

## Customization

### Adding More Packages

Edit `Brewfile` and add packages:

```ruby
# CLI tool
brew "package-name"

# GUI application
cask "application-name"

# Font
cask "font-name"
```

Then run:
```bash
brew bundle --file=~/dotfiles/Brewfile
```

### Modifying Shell Configuration

Your configuration files are **symlinked**, meaning `~/.zshrc` points directly to `~/.dotfiles/.zshrc`.

You can edit either location:
- `~/.zshrc` (in your home directory)
- `~/.dotfiles/.zshrc` (in your dotfiles repo)

Both point to the same file! Changes made to one are automatically reflected in the other.

Edit to customize:
- Aliases
- Functions
- Environment variables
- PATH additions

Changes take effect on new terminal sessions or run:
```bash
source ~/.zshrc
```

To commit your changes to git:
```bash
cd ~/.dotfiles
git add .zshrc
git commit -m "Update zsh config"
git push
```

## Maintenance

### Update Packages

```bash
brew update
brew upgrade
brew cleanup
```

### Update zsh4humans

```bash
z4h update
```

### Backup Current Configuration

Your configs are symlinked from the dotfiles directory, so they're already backed up in git. Commit changes:

```bash
cd ~/.dotfiles
git add .
git commit -m "Update configurations"
git push
```

## Troubleshooting

### NVM not working

Make sure NVM is installed via Homebrew:
```bash
brew install nvm
mkdir ~/.nvm
```

Then restart your terminal.

### Eza command not found

Install eza via Homebrew:
```bash
brew install eza
```

### Alacritty not using custom config

Check if config exists:
```bash
ls -la ~/.config/alacritty/alacritty.toml
```

If missing, rerun the install script or manually symlink:
```bash
ln -sf ~/.dotfiles/config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
```

### Shell not changed to zsh

Manually change shell:
```bash
chsh -s $(which zsh)
```

Then restart your terminal.

## Uninstall

To restore previous configurations:

1. Remove symlinks:
```bash
rm ~/.zshrc ~/.logo.txt
rm ~/.config/alacritty/alacritty.toml
```

2. Restore from backups (they have `.backup.YYYYMMDD_HHMMSS` suffix):
```bash
ls ~/*.backup.*
mv ~/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc
```

## License

MIT

## Credits

- [zsh4humans](https://github.com/romkatv/zsh4humans) - Zsh configuration framework
- [Homebrew](https://brew.sh/) - Package manager for macOS
- [Alacritty](https://alacritty.org/) - GPU-accelerated terminal emulator
