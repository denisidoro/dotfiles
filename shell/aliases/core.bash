#!/usr/bin/env bash

# ========================
# terminal
# ========================
alias c='clear'
alias faketty='dot script faketty'
alias ansi='dot script ansi'
alias icat="kitty +kitten icat --align=left"
# alias ssh="kitty +kitten ssh"

# ========================
# shell
# ========================
alias reload='source "${HOME}/.$(basename $SHELL)rc"' # env -i zsh

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
alias vim='v'
alias nvim='v'
alias vi='v'
alias code='e'

# ========================
# utils
# ========================
# alias fzf='fzf-tmux'
alias d='dot'
alias n="navi"
alias browser="dot script open -b"
alias color="dot script color"

# ========================
# git
# ========================
source "${DOTFILES}/shell/aliases/git.bash"

# ========================
# phabricator
# ========================
alias ac="arc diff --create --nounit --nolint --excuse=ci"
alias ad="arc diff --nounit --nolint --excuse=ci"
alias au="navi best 'Update a diff'"
alias al="navi best 'Land a diff'"
uc() { navi --best-match --query "uber creds $@"; }
alias arcx="dot phabricator arcx"

# ========================
# projects
# ========================
sc() { "./scripts/$@"; }

# ========================
# explorer
# ========================

alias o="dot script dashed open --"
unalias f &> /dev/null
# alias f="dot script dashed vifm --"
# alias ls='ls --color=auto'
alias lst="tree -L 2"
cdd() { cd "$@" && ls .; }
mkcd() { mkdir -p -- "$@" && cd -P -- "$@"; }

_safe_cd() {
   # [[ -z "${1:-}" ]] && return 1 || true
   [[ -d "${1:-}" ]] && cd "$1" || echoerr "$1 doesn't exist"
}

j() { _safe_cd "$(dot fs jump global "$@")"; }
jj() { _safe_cd "$(dot fs jump local "$@")"; }
# ju() { _safe_cd "$(dot uber projects --clone local "$@")"; }
ju() { _safe_cd "$(dot fs jump work "$@")"; }
jd() { _safe_cd "$(dot fs jump dev "$@")"; }
jjf() { _safe_cd "$(dot fs jump file "$@")"; }
jr() { _safe_cd "$(dot fs jump root "$@")"; }
up() { _safe_cd "$(dot fs jump up "$@")"; }
alias jv="dot fs jump edit global nvim"
alias jjv="dot fs jump edit local nvim"
alias js="dot fs jump edit global code"
alias jjs="dot fs jump edit local code"

# ========================
# misc
# ========================
alias pr='gpr'
alias mono="dot work mono"

# debug() {
#    dot shell log info "$@"
#    "$@"
# }