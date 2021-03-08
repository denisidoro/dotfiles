#!/usr/bin/env bash

log::ansi() {
   dot terminal ansi "$@"
}

log::_log() {
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

log::_export() {
   case "$1" in
      header) [ -z "${_templ_header:-}" ] && _templ_header="$(log::ansi --magenta _)" || true ;;
      warn) [ -z "${_templ_warn:-}" ] && _templ_warn_pre="$(log::ansi --yellow --inverse _)" && _templ_warn="$(log::ansi --yellow _)" || true ;;
      err) [ -z "${_templ_err:-}" ] && _templ_err_pre="$(log::ansi --red --inverse _)" && _templ_err="$(log::ansi --red _)" || true ;;
      success) [ -z "${_templ_success:-}" ] && _templ_success_pre="$(log::ansi --green --inverse _)" && _templ_success="$(log::ansi --green _)" || true ;;
      info) [ -z "${_templ_info:-}" ] && _templ_info_pre="$(log::ansi --bg-blue _)" && _templ_info="$(log::ansi --blue _)" || true ;;
   esac
}

log::header() { log::_export header && log::_log "${_templ_header/_/$(log::_header "$@")}"; }
log::warn() { log::_export warn && log::_log "${_templ_warn_pre/_/ WARN } ${_templ_warn/_/$@}"; }
log::err() { log::_export err && log::_log "${_templ_err_pre/_/ ERR  } ${_templ_err/_/$@}"; }
log::success() { log::_export sucess && log::_log "${_templ_success_pre/_/ SUCC } ${_templ_succ/_/$@}"; }
log::info() { log::_export info && log::_log "${_templ_info_pre/_/ INFO } ${_templ_info/_/$@}"; }

die() {
   log::err "$@"
   exit 42
}

tap() {
   local -r input="$(cat)"
   echoerr "$input"
   echo "$input"
}