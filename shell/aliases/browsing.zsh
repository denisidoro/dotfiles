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
# alias ls='lsd'
alias lst="tree -L 2"
cd() {
   builtin cd "$@" && (lsd . 2>/dev/null || ls .)
}

# ===============
# folders
# ===============

mkcd() {
   mkdir -p -- "$@" && cd -P -- "$@"
}

# ===============
# jumping
# ===============
_safe_cd() { [[ -d "${1:-}" ]] && cd "$1"; }
j() { _safe_cd "$(dot fs jump global "$@")"; }
jj() { _safe_cd "$(dot fs jump local "$@")"; }
jn() { _safe_cd "$(dot fs jump work "$@")"; }
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
