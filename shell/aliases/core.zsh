#!/usr/bin/env bash
# vim: filetype=sh

# ========================
# terminal
# ========================
alias c='clear'
alias t='tmux'
alias tt='dot shell tmux tat'
alias tl='dot shell tmux ls'
alias tn='dot shell tmux new'
alias ta='dot shell tmux attach'
alias tk='dot shell tmux kill'

# ========================
# shell
# ========================
alias reload='source ~/.zshrc' # env -i zsh

# ========================
# scripting
# ========================
alias map='xargs -I%'

# ========================
# editors
# ========================
alias vim='nvim'
alias v="dot_or_args nvim --"

# ========================
# utils
# ========================
alias d='dot'
alias n="navi"

# ========================
# git
# ========================
source "${DOTFILES}/shell/aliases/git.zsh"

# ========================
# phabricator
# ========================
alias ac="arc diff --create"
alias au="navi best 'Update a diff'"
alias al="navi best 'Land a diff'"

# ========================
# explorer
# ========================

alias o="dot_or_args open --"
unalias f &> /dev/null
alias f="dot_or_args vifm --"

# alias ls='ls --color=auto'
# alias ls='lsd'
alias lst="tree -L 2"
cd() {
   builtin cd "$@" && (lsd . 2>/dev/null || ls .)
}

mkcd() {
   mkdir -p -- "$@" && cd -P -- "$@"
}

_safe_cd() { [[ -d "${1:-}" ]] && cd "$1" || echoerr "$1 doesn't exist"; }
j() { _safe_cd "$(dot fs jump global "$@")"; }
jj() { _safe_cd "$(dot fs jump local "$@")"; }
ju() { _safe_cd "$(navi best 'uber path to a project')"; }
jd() { _safe_cd "$(dot fs jump dev "$@")"; }
jjf() { _safe_cd "$(dot fs jump file "$@")"; }
up() { _safe_cd "$(dot fs jump up "$@")"; }
jr() { _safe_cd "$(dot fs jump root "$@")"; }
jr() { _safe_cd "$(dot fs jump root "$@")"; }
fd() { _safe_cd "$(dot fs nav "$@")"; }
alias jv="dot fs jump edit global nvim"
alias jjv="dot fs jump edit local nvim"
alias js="dot fs jump edit global code"
alias jjs="dot fs jump edit local code"
