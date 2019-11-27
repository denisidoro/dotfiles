#!/usr/bin/env bash

_export_colors() {
   if ! ${DOT_COLORS_EXPORTED:-false}; then
      log_black=30
      log_red=31
      log_green=32
      log_yellow=33
      log_blue=34
      log_purple=35
      log_cyan=36
      log_white=37

      log_regular=0
      log_bold=1
      log_underline=4

      readonly DOT_COLORS_EXPORTED=true
   fi
}

log::ansi() {
   _export_colors
   local bg=false
   case "$@" in
      *reset*) echo "\e[0m"; return 0 ;;
      *black*) color=$log_black ;;
      *red*) color=$log_red ;;
      *green*) color=$log_green ;;
      *yellow*) color=$log_yellow ;;
      *blue*) color=$log_blue ;;
      *purple*) color=$log_purple ;;
      *cyan*) color=$log_cyan ;;
      *white*) color=$log_white ;;
   esac
   case "$@" in
      *regular*) mod=$log_regular ;;
      *bold*) mod=$log_bold ;;
      *underline*) mod=$log_underline ;;
   esac
   case "$@" in
      *background*) bg=true ;;
      *bg*) bg=true ;;
   esac

   if $bg; then
      echo "\e[${color}m"
   else
      echo "\e[${mod:-$log_regular};${color}m"
   fi
}

if [ -z ${DOT_LOG_FILE+x} ]; then
   readonly DOT_LOG_FILE="/tmp/$(basename "$0").log"
fi

_log() {
   local template=$1
   shift
   if ${log_to_file:-false}; then
      echoerr -e $(printf "$template" "$@") | tee -a "$DOT_LOG_FILE" >&2
   else
      echoerr -e $(printf "$template" "$@")
   fi
}

_header() {
   local TOTAL_CHARS=60
   local total=$TOTAL_CHARS-2
   local size=${#1}
   local left=$((($total - $size) / 2))
   local right=$(($total - $size - $left))
   printf "%${left}s" '' | tr ' ' =
   printf " $1 "
   printf "%${right}s" '' | tr ' ' =
}

log::header() { _export_colors && _log "\n$(log::ansi bold)$(log::ansi purple)$(_header "$1")$(log::ansi reset)\n"; }
log::success() { _export_colors && _log "$(log::ansi green)✔ %s$(log::ansi reset)\n" "$@"; }
log::error() { _export_colors && _log "$(log::ansi red)✖ %s$(log::ansi reset)\n" "$@"; }
log::warning() { _export_colors && _log "$(log::ansi yellow)➜ %s$(log::ansi reset)\n" "$@"; }
log::note() { _export_colors && _log "$(log::ansi blue)%s$(log::ansi reset)\n" "$@"; }

die() {
   log::error "$@"
   exit 42
}
