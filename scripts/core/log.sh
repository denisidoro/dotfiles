#!/usr/bin/env bash

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
log::info() { echoerr "$(log::ansi --green --inverse '    INFO ')" "$(log::ansi --green "$@")"; }
log::debug() { echoerr "$(log::ansi --blue --inverse '   DEBUG ')" "$(log::ansi --blue "$@")"; }
log::trace() { echoerr "$(log::ansi --magenta --inverse '   TRACE ')" "$(log::ansi --magenta "$@")"; }

die() {
   log::fatal "$@"
   exit 42
}

tap() {
   local -r input="$(cat)"
   echoerr "$input"
   echo "$input"
}