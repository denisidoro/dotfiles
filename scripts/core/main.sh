#!/usr/bin/env zsh

echoerr() {
   echo "$@" 1>&2
}

println() {
   print '%s\n' "$@"
}

tap() {
   local -r input="$(cat)"
   echoerr "$input"
   echo "$input"
}

has() {
   type "$1" &>/dev/null
}

export_f() {
   export -f "$@" >/dev/null
}

export_f has tap println echoerr

if has doc::parse; then
   return 0
fi

export PATH="${DOTFILES}/bin/:${PATH}:/usr/local/bin:/usr/bin:${HOME}/bin"

if ${DOT_TRACE:-false}; then
   export PS4='+'$'\t''\e[1;30m\t \e[1;39m$(printf %4s ${SECONDS}s) \e[1;31m$(printf %3d $LINENO) \e[1;34m$BASH_SOURCE \e[1;32m${FUNCNAME[0]:-}\e[0m: '
   set -x
fi

export EDITOR="${EDITOR:-vi}"

if ! has sudo; then
   sudo() { "$@"; }
   export_f sudo
fi

if ! has tput; then
   tput() { :; }
   export_f tput
fi

if has gcat; then
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
   export_f sed awk find head mktemp date cut tr cp cat sort kill xargs
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

   case "${!#:-}" in
      -h|--help|--version) doc::help_msg "$file"; exit 0 ;;
   esac

   echoerr "Invalid command"
   echoerr
   doc::help_msg "$file"
   exit 1
}

doc::parse() {
   local -r file="$0"
   local -r help="$(doc::help_msg "$file")"

   if [ -z ${DOT_DOCOPT:-} ]; then
      if has python; then
         DOT_DOCOPT="python"
      else
         (dot pkg add docpars >/dev/null && DOT_DOCOPT="$(which docpars)") \
            || (dot pkg add python >/dev/null && DOT_DOCOPT="python")
      fi
   fi

   if [[ $DOT_DOCOPT == "python" ]]; then
      local -r docopt="${DOTFILES}/scripts/core/docopts"
   else
      local -r docopt="$DOT_DOCOPT"
   fi

   eval "$("$docopt" -h "${help}" : "${@:1}")"
}

export_f doc::help_msg doc::maybe_help doc::help_or_fail doc::parse
