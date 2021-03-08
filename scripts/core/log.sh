#!/usr/bin/env bash

log::ansi() {
   dot terminal ansi "$@"
}

log::_log() {
   local template=$1
   shift
   echoerr -e $(printf "$template" "$@")
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

log::header() { log::_log "$(log::ansi --magenta "$(log::_header "$@")")\n"; }
log::warn() { log::_log "$(log::ansi --yellow --inverse " WARN ") $(log::ansi --yellow "$@")\n"; }
log::err() { log::_log "$(log::ansi --red --inverse "⠀⠀ERR⠀") $(log::ansi --red "$@")\n"; }
log::success() { log::_log "$(log::ansi --green --inverse " SUCC ") $(log::ansi --green "$@")\n"; }
log::info() { log::_log "$(log::ansi --bg-blue" INFO ") $(log::ansi --blue "$@")\n"; }

die() {
   log::err "$@"
   exit 42
}

tap() {
   local -r input="$(cat)"
   echoerr "$input"
   echo "$input"
}