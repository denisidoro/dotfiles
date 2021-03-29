#!/usr/bin/env bash

# ========================
# terminal
# ========================
alias c='clear'
alias t='tmux'
alias tt='dot terminal tmux tat'
alias tl='dot terminal tmux ls'
alias tn='dot terminal tmux new'
alias ta='dot terminal tmux attach'
alias tk='dot terminal tmux kill'
alias faketty='dot terminal abra faketty'
alias rxout='dot terminal abra rxout'
alias rxerr='dot terminal abra rxerr'
alias txspl='dot terminal abra txspl'
alias rxls='dot terminal abra rxls'
txls() { eval "$(abra hook "$DOT_SHELL")"; }
alias bt='bat -p'
alias ansi='dot terminal ansi'
alias icat="kitty +kitten icat --align=left"
alias ssh="kitty +kitten ssh"

# ========================
# shell
# ========================
alias reload='source "${HOME}/.${DOT_SHELL:-zsh}rc' # env -i zsh

# ========================
# kitty
# ========================
alias fw='navi --best-match -q "kitty focus window"'

# ========================
# scripting
# ========================
alias map='xargs -I%'

# ========================
# editors
# ========================
alias vim='nvim'
alias v="dot terminal dashed nvim --"
alias code='dot terminal dashed dot code vscode --'
alias e='code'

# ========================
# utils
# ========================
# alias fzf='fzf-tmux'
alias d='dot'
alias n="navi"
alias browser="dot terminal open -b"
alias chrome="dot terminal open -b"
alias color="dot terminal color"

# ========================
# git
# ========================
source "${DOTFILES}/shell/aliases/git.bash"

# ========================
# phabricator
# ========================
alias ac="arc diff --create --nounit --nolint"
alias ad="arc diff --nounit --nolint"
alias au="navi best 'Update a diff'"
alias al="navi best 'Land a diff'"

# ========================
# explorer
# ========================

alias o="dot terminal dashed open --"
unalias f &> /dev/null
alias f="dot terminal dashed vifm --"
# alias ls='ls --color=auto'
alias lst="tree -L 2"
cdd() { cd "$@" && ls .; }
mkcd() { mkdir -p -- "$@" && cd -P -- "$@"; }

_safe_cd() {
   [[ -z "${1:-}" ]] && return 1 || true
   [[ -d "${1:-}" ]] && cd "$1" || echoerr "$1 doesn't exist"
}

j() { _safe_cd "$(dot fs jump global "$@")"; }
jj() { _safe_cd "$(dot fs jump local "$@")"; }
ju() { _safe_cd "$(dot uber projects --clone local "$@")"; }
jd() { _safe_cd "$(dot fs jump dev "$@")"; }
jjf() { _safe_cd "$(dot fs jump file "$@")"; }
jr() { _safe_cd "$(dot fs jump root "$@")"; }
jr() { _safe_cd "$(dot fs jump root "$@")"; }
fdd() { _safe_cd "$(dot fs nav "$@")"; }
up() { _safe_cd "$(dot fs jump up "$@")"; }
alias jv="dot fs jump edit global nvim"
alias jjv="dot fs jump edit local nvim"
alias js="dot fs jump edit global code"
alias jjs="dot fs jump edit local code"
