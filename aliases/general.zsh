# ===============
# shortcuts
# ===============
alias c='clear'
alias reload='source ~/.zshrc' # env -i zsh


# ===============
# helpers
# ===============

include() {
    [[ -f "$1" ]] && source "$1"
}

