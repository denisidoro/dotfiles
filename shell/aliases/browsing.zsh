#!/usr/bin/env bash
# vim: filetype=sh

# ===============
# explorer
# ===============

alias o="dot_or_args open --"
unalias f &> /dev/null
alias f="dot_or_args vifm --"

# ===============
# listing
# ===============

# alias ls='ls --color=auto'
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
j() { local readonly f="$(dot fs jump global "$@")" && cd "$f"; }
jj() { local readonly f="$(dot fs jump local "$@")" && cd "$f"; }
jn() { local readonly f="$(dot fs jump work "$@")" && cd "$f"; }
jjf() { local readonly f="$(dot fs jump file "$@")" && cd "$f"; }
up() { local readonly f="$(dot fs jump up "$@")" && cd "$f"; }
jr() { local readonly f="$(dot fs jump root "$@")" && cd "$f"; }
jr() { local readonly f="$(dot fs jump root "$@")" && cd "$f"; }
fd() { local readonly f="$(dot fs nav "$@")" && cd "$f"; }
alias jv="dot fs jump edit global nvim"
alias jjv="dot fs jump edit local nvim"
alias js="dot fs jump edit global code"
alias jjs="dot fs jump edit local code"
