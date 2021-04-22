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
   "--blue--inverse") printf "\033[34m\033[7m${txt}\033[27;39m" ;; 
   "--blue") printf "\033[34m${txt}\033[39m" ;; 
   "--magenta") printf "\033[35m${txt}\033[39m" ;; 
   "--yellow--inverse") printf "\033[33m\033[7m${txt}\033[27;39m" ;; 
   "--yellow") printf "\033[33m${txt}\033[39m" ;; 
   "--red--inverse") printf "\033[31m\033[7m${txt}\033[27;39m" ;; 
   "--red") printf "\033[31m${txt}\033[39m" ;; 
   "--green--inverse") printf "\033[32m\033[7m${txt}\033[27;39m" ;; 
   "--green") printf "\033[32m${txt}\033[39m" ;; 
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
   local left=$((($total - $size) / 2))
   local right=$(($total - $size - $left))
   printf "%${left}s" '' | tr ' ' =
   printf " $1 "
   printf "%${right}s" '' | tr ' ' =
}

log::header() { log::_stderr $(log::ansi --magenta "$(log::_header $@)"); }
log::warn() { log::_stderr $(log::ansi --yellow --inverse '    WARN ') $(log::ansi --yellow $@); }
log::err() { log::_stderr $(log::ansi --red --inverse '   ERROR ') $(log::ansi --red $@); }
log::success() { log::_stderr $(log::ansi --green --inverse ' SUCCESS ') $(log::ansi --green $@); }
log::info() { log::_stderr $(log::ansi --blue --inverse '    INFO ') $(log::ansi --blue $@); }

die() {
   log::err "$@"
   exit 42
}

tap() {
   local -r input="$(cat)"
   echoerr "$input"
   echo "$input"
}