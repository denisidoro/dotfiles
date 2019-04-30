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
j() { local readonly f="$(dot -d shell jump global "$@")" && cd "$f"; }
jj() { local readonly f="$(dot -d shell jump local "$@")" && cd "$f"; }
jn() { local readonly f="$(dot -d shell jump work "$@")" && cd "$f"; }
jjf() { local readonly f="$(dot -d shell jump file "$@")" && cd "$f"; }
up() { local readonly f="$(dot -d shell jump up "$@")" && cd "$f"; }
jr() { local readonly f="$(dot -d shell jump root "$@")" && cd "$f"; }
alias jv="dot -d shell jump edit global nvim"
alias jjv="dot -d shell jump edit local nvim"
alias js="dot -d shell jump edit global subl"
alias jjs="dot -d shell jump edit local subl"
