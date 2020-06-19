#!/usr/bin/env bash

# if ${DOT_MAIN_SOURCED:-false}; then
#    return 0
# fi

echoerr() {
   echo "$@" 1>&2
}

has() {
   type "$1" &>/dev/null
}

export -f has echoerr

if ${DOT_TRACE:-false}; then
   export PS4='+'$'\t''\e[1;30m\t \e[1;39m$(printf %4s ${SECONDS}s) \e[1;31m$(printf %3d $LINENO) \e[1;34m$BASH_SOURCE \e[1;32m${FUNCNAME[0]:-}\e[0m: '
   set -x
fi

export EDITOR="${EDITOR:-vi}"

if ! has dot; then
   export PATH="${DOTFILES}/bin/:${PATH}"
fi

if ! has sudo; then
   sudo() { "$@"; }
   export -f sudo
fi

if ! has tput; then
   tput() { :; }
   export -f tput
fi

if has ggrep; then
   sed() { gsed "$@"; }
   awk() { gawk "$@"; }
   find() { gfind "$@"; }
   grep() { ggrep "$@"; }
   head() { ghead "$@"; }
   mktemp() { gmktemp "$@"; }
   ls() { gls "$@"; }
   date() { gdate "$@"; }
   cut() { gcut "$@"; }
   tr() { gtr "$@"; }
   cp() { gcp "$@"; }
   cat() { gcat "$@"; }
   sort() { gsort "$@"; }
   kill() { gkill "$@"; }
   xargs() { gxargs "$@"; }
   export -f sed awk find head mktemp date cut tr cp cat sort kill xargs
fi

doc::help_msg() {
   local -r file="$1"
   grep "^##?" "$file" | cut -c 5-
}

doc::maybe_help() {
   local -r file="$0"

   case "${!#:-}" in
      -h|--help|--version) doc::help_msg "$file"; exit 0 ;;
   esac
}

doc::help_or_fail() {
   local -r file="$0"

   doc::help_msg "$file"
   exit 1
}

doc::parse() {
   local -r file="$0"
   local -r help="$(doc::help_msg "$file")"

   if [[ ${DOT_DOCOPT:-python} == "python" ]]; then
      local -r docopt="${DOTFILES}/scripts/core/docopts"
   else
      local -r docopt="$DOT_DOCOPT"
   fi

   eval "$("$docopt" -h "${help}" : "${@:1}")"
}

export -f doc::maybe_help doc::help_or_fail doc::parse

export DOT_MAIN_SOURCED=true
