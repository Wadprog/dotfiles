# zsh Options
setopt HIST_IGNORE_ALL_DUPS

# Display logo
cat ~/.logo.txt

#export key for gpg
export GPG_TTY=$(tty)

#Custom zsh
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"

# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"