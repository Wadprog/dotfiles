# Git 
alias g='git'
alias ga='git add'
alias gf='git fetch'
alias gs='git status'
alias gss='git status -s'
alias gup='git fetch && git rebase'
alias glo='git pull origin'
alias gl='git pull'
alias gb='git branch '
alias gbr='git branch -r'
alias gd='git diff'
alias gco='git checkout '
alias gcob='git checkout -b '
alias gcofzf='git branch | fzf | xargs git checkout' # Select branch with fzf
alias gre='git remote'
alias gres='git remote show'
alias glgg='git log --graph --max-count=5 --decorate --pretty="oneline"'
alias gm='git merge'
alias gp='git push'
alias gpo='git push origin'
alias ggpush='git push origin $(current_branch)'
alias gc='git commit -v'
alias gcm='git commit -m'

# Function to commit with ticket ID from current branch, with optional push
quick_commit() {
  local branch_name ticket_id commit_message push_flag
  branch_name=$(git branch --show-current)
  ticket_id=$(echo "$branch_name" | awk -F '-' '{print toupper($1"-"$2)}')
  commit_message="$ticket_id: $*"
  push_flag=$1

  if [[ "$push_flag" == "push" ]]; then
    # Remove 'push' from the commit message
    commit_message="$ticket_id: ${*:2}" # take all positional parameters starting from the second one
    git commit --no-verify -m "$commit_message" && git push
  else
    git commit --no-verify -m "$commit_message"
  fi
}

alias gqc='quick_commit'
alias gqcp='quick_commit push'
alias cd='z'
# Better ls
alias ls="eza --grid --all --icons=always"

# Lazygit
alias lg="lazygit"
