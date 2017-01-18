# vim
alias vim='nvim'
alias v='nvim'

# shortcuts
alias c='clear'
alias reload='source ~/.zshrc' # env -i zsh

# git
alias gcdr='cd $(git rev-parse --show-toplevel)'
alias gpu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
gcol() {
  if [[ $# -eq 0 ]]; then
    git branch --sort=-committerdate | head -n 6 | sed '/^\*/ d' | nl -nrz -w1 
  else
  	git checkout $(git branch --sort=-committerdate | sed '/^\*/ d' | awk -v n=$1 'NR == n')
  fi
}

# browsing
alias ls='ls --color=auto'
alias lst="tree -L 2"
