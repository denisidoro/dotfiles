#!/usr/bin/env bash

if ${DOT_DEBUG:-false}; then
   set -x
fi

echoerr() {
   echo "$@" 1>&2
}

println() {
   print '%s\n' "$@"
}

tap() {
   # shellcheck disable=SC2119
   local -r input="$(cat)"
   echoerr "$input"
   echo "$input"
}

log::ansi() {
   local -r all_args=("$@")
   local -r mod1="$1"
   local mod2=""
   shift || true
   if [ "${1:-}" = "--inverse" ]; then
      mod2="$1"
      shift
   fi
   local -r txt="$*"
   case "${mod1}${mod2}" in
      "--blue") printf "\033[34m%s\033[39m" "$txt" ;;
      "--blue--inverse") printf "\033[34m\033[7m%s\033[27;39m" "$txt" ;;
      "--magenta") printf "\033[35m%s\033[39m" "$txt" ;;
      "--magenta--inverse") printf "\033[35m\033[7m%s\033[27;39m" "$txt" ;;
      "--yellow") printf "\033[33m%s\033[39m" "$txt" ;;
      "--yellow--inverse") printf "\033[33m\033[7m%s\033[27;39m" "$txt" ;;
      "--red") printf "\033[31m%s\033[39m" "$txt" ;;
      "--red--inverse") printf "\033[31m\033[7m%s\033[27;39m" "$txt" ;;
      "--green") printf "\033[32m%s\033[39m" "$txt" ;;
      "--green--inverse") printf "\033[32m\033[7m%s\033[27;39m" "$txt" ;;
      *) dot terminal ansi "${all_args[@]}" ;;
   esac
}

log::_header() {
   local TOTAL_CHARS=60
   local total=$TOTAL_CHARS-2
   local size=${#1}
   local left=$(((total - size) / 2))
   local right=$((total - size - left))
   printf "%${left}s" '' | tr ' ' =
   printf " %s " "$1"
   printf "%${right}s" '' | tr ' ' =
}

log::fatal() { echoerr "$(log::ansi --red --inverse '   FATAL ')" "$(log::ansi --red --inverse "$@")"; }
log::error() { echoerr "$(log::ansi --red --inverse '   ERROR ')" "$(log::ansi --red "$@")"; }
log::warn() { echoerr "$(log::ansi --yellow --inverse '    WARN ')" "$(log::ansi --yellow "$@")"; }
log::success() { echoerr "$(log::ansi --green --inverse ' SUCCESS ')" "$(log::ansi --green "$@")"; }
log::info() { echoerr "$(log::ansi --magenta --inverse '    INFO ')" "$(log::ansi --magenta "$@")"; }
log::debug() { echoerr "$(log::ansi --blue --inverse '   DEBUG ')" "$(log::ansi --blue "$@")"; }
log::trace() { echoerr "$(log::ansi --blue --inverse '   TRACE ')" "$(log::ansi --blue "$@")"; }

die() {
   log::fatal "$@"
   exit 42
}

debug() {
   log::info "$@"
   "$@"
}

has() {
   type "$1" &>/dev/null
}

export_f() {
   export -f "${@?}" >/dev/null
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
   # shellcheck disable=SC2120
   cat() { gcat "$@"; }
   sort() { gsort "$@"; }
   kill() { gkill "$@"; }
   xargs() { gxargs "$@"; }
   export_f sed awk find head mktemp date cut tr cp cat sort kill xargs
fi

doc::help_msg() {
   local -r sh_file="$1"
   grep "^##?" "$sh_file" | cut -c 5-
}

doc::maybe_help() {
   local -r sh_file="$0"

   doc::autocomplete "$@"

   case "${1:-}" in
      -h|--help|--version) doc::help_msg "$sh_file"; exit 0 ;;
   esac
}

doc::help_or_fail() {
   local -r sh_file="$0"

   doc::autocomplete "$@"

   case "${1:-}" in
      -h|--help|--version) doc::help_msg "$sh_file"; exit 0 ;;
   esac

   echoerr "Invalid command"
   echoerr
   doc::help_msg "$sh_file"
   exit 1
}

doc::parse() {
   local -r sh_file="$0"

   doc::autocomplete "$@"

   local -r help="$(doc::help_msg "$sh_file")"
   local docopt="${DOT_DOCOPT:-}"

   if [ -z "${docopt:-}" ]; then
      if has python; then
         docopt="python"
      else
         if dot pkg add docpars >/dev/null; then
            docopt="$(which docpars)"
         else
            dot pkg add python >/dev/null
            docopt="python"
         fi
      fi
   fi

   if [[ $docopt == "python" ]]; then
      docopt="${DOTFILES}/scripts/core/docopts"
   else
      docopt="$DOT_DOCOPT"
   fi

   eval "$("$docopt" -h "${help}" : "${@:1}")"
}

doc::autocomplete() {
   if [ "${1:-}" != "_autocomplete" ]; then
      return 0
   fi

   shift

   if ! has _autocomplete; then
      exit 99
   fi

   local -r out="$(_autocomplete "$@")"
   if [ -n "$out" ]; then
      echo "$out"
      exit 0
   else 
      exit 1
   fi
}

export_f doc::help_msg doc::maybe_help doc::help_or_fail doc::parse doc::autocomplete
