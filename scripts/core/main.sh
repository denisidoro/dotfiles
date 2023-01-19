#!/usr/bin/env bash

has() {
   type "$1" &>/dev/null
}

if has doc::maybe_help; then 
   return 0
fi

# echo "IMPORTED MAIN: $0" >&2

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
      "--bold") printf "\033[1m%s\033[0m" "$txt" ;;
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
      *) dot script ansi "${all_args[@]}" ;;
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

export_f() {
   export -f "${@?}" >/dev/null
}

yaml::export() {
   if ${DOT_YAML_PARSED:-false}; then
      return 0
   fi

   eval "$(dot script yaml "${DOTFILES}/config.yaml" "DOT_")"

   local -r override="${DOTFILES}/local/config.yaml"
   if [ -f "$override" ]; then
      eval "$(dot script yaml "$override" "DOT_")"
   fi

   export DOT_YAML_PARSED=true
}

yaml::var() {
   local -r varname="DOT_${1:-}"

   yaml::export

   if [ -z "${!varname:-}" ]; then
      local -r default="${2:-false}"
      echo "$default"
      return 0
   fi

   echo "${!varname}"
}

export PATH="${DOTFILES}/bin/:${PATH}:/usr/local/bin:/usr/bin:${HOME}/bin"

if ${DOT_TRACE:-false}; then
   export PS4='+'$'\t''\e[1;30m\t \e[1;39m$(printf %4s ${SECONDS}s) \e[1;31m$(printf %3d $LINENO) \e[1;34m$BASH_SOURCE \e[1;32m${FUNCNAME[0]:-}\e[0m: '
   set -x
fi

export EDITOR="${EDITOR:-v}"

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
   # shellcheck disable=SC2120
   xargs() { gxargs "$@"; }
   export_f sed awk find head mktemp date cut tr cp cat sort kill xargs
fi

doc::_help_msg() {
   local -r sh_file="$1"
   grep "^##?" "$sh_file" | cut -c 5-
}

doc::maybe_help() {
   local -r sh_file="$0"
   
   local show_if_no_args=false
   if [ "${1:-}" = "--show-if-no-args" ]; then
      shift || true
      show_if_no_args=true
   fi

   doc::handle "$@"

   if $show_if_no_args && [ $# = 0 ]; then
      doc::_help_msg "$sh_file"
      exit 0 
   fi

   case "${1:-}" in
      -h|--help|--version) doc::_help_msg "$sh_file"; exit 0 ;;
   esac
}

doc::parse() {
   local -r sh_file="$0"

   doc::handle "$@"

   local -r help="$(doc::_help_msg "$sh_file")"
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

doc::install_deps() {
   local -r deps="$(doc::_help_msg "$0" \
      | awk '/Depends on/,/^$/' \
      | tail -n +2 \
      | xargs)"

   IFS=' '
   for dep in $deps; do
      dot pkg add "$dep"
   done

   exit 0
}

doc::handle() {
   case "${1:-}" in
      "_autocomplete") shift; doc::autocomplete "$@" ;;
      "_install_deps") shift; doc::install_deps "$@" ;;
   esac
}
