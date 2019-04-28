#!/usr/bin/env bash
# vim: filetype=sh

# ===============
# explorer
# ===============

alias o="dot_or_args open --"
alias r="dot_or_args ranger --"

# ===============
# listing
# ===============

alias ls='ls --color=auto'
alias lst="tree -L 2"

# ===============
# folders
# ===============

mkcd() {
    mkdir -p -- "$@" && cd -P -- "$@"
}

# ===============
# jumping
# ===============
j() { local readonly f="$(dot shell jump global "$@")" && cd "$f" }
jj() { local readonly f="$(dot shell jump local "$@")" && cd "$f" }
jn() { local readonly f="$(dot shell jump work "$@")" && cd "$f" }
jjf() { local readonly f="$(dot shell jump file "$@")" && cd "$f" }
up() { local readonly f="$(dot shell jump up "$@")" && cd "$f" }
jr() { local readonly f="$(dot shell jump root "$@")" && cd "$f" }
alias jv="dot shell jump edit global nvim"
alias jjv="dot shell jump edit local nvim"
alias js="dot shell jump edit global subl"
alias jjs="dot shell jump edit local subl"
