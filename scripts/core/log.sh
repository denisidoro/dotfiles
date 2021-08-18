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
      "--blue--inverse") printf "\033[34m\033[7m%s\033[27;39m" "$txt" ;;
      "--blue") printf "\033[34m%s\033[39m" "$txt" ;;
      "--magenta") printf "\033[35m%s\033[39m" "$txt" ;;
      "--yellow--inverse") printf "\033[33m\033[7m%s\033[27;39m" "$txt" ;;
      "--yellow") printf "\033[33m%s\033[39m" "$txt" ;;
      "--red--inverse") printf "\033[31m\033[7m%s\033[27;39m" "$txt" ;;
      "--red") printf "\033[31m%s\033[39m" "$txt" ;;
      "--green--inverse") printf "\033[32m\033[7m%s\033[27;39m" "$txt" ;;
      "--green") printf "\033[32m%s\033[39m" "$txt" ;;
      *) dot terminal ansi "${all_args[@]}" ;;
   esac
}

log::_stderr() {
   echoerr -e "$*"
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

log::header() { log::_stderr "$(log::ansi --magenta "$(log::_header "$@")")"; }
log::warn() { log::_stderr "$(log::ansi --yellow --inverse '    WARN ')" "$(log::ansi --yellow "$@")"; }
log::err() { log::_stderr "$(log::ansi --red --inverse '   ERROR ')" "$(log::ansi --red "$@")"; }
log::success() { log::_stderr "$(log::ansi --green --inverse ' SUCCESS ')" "$(log::ansi --green "$@")"; }
log::info() { log::_stderr "$(log::ansi --blue --inverse '    INFO ')" "$(log::ansi --blue "$@")"; }

die() {
   log::err "$@"
   exit 42
}

tap() {
   local -r input="$(cat)"
   echoerr "$input"
   echo "$input"
}