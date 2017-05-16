#!/usr/bin/env bash

bold=$(tput bold)
underline=$(tput sgr 0 1)
freset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

readonly LOG_FILE="/tmp/$(basename "$0").log"

function _log() {
  local template=$1
  shift
  if ${log_to_file:-false}; then
    echo -e $(printf "$template" "$@") | tee -a "$LOG_FILE" >&2; 
  else
    echo -e $(printf "$template" "$@")
  fi
}

function _header() {
  local TOTAL_CHARS=60
  local total=$TOTAL_CHARS-2
  local size=${#1}
  local left=$((($total - $size) / 2))
  local right=$(($total - $size - $left))
  printf "%${left}s" '' | tr ' ' =
  printf " $1 "
  printf "%${right}s" '' | tr ' ' =
}

function header() { _log "\n${bold}${purple}$(_header "$1")${freset}\n"; }
function success() { _log "${green}✔ %s${freset}\n" "$@"; }
function error() { _log "${red}✖ %s${freset}\n" "$@"; }
function warning() { _log "${tan}➜ %s${freset}\n" "$@"; }
function note() { _log "${underline}${bold}${blue}Note:${freset} ${blue}%s${freset}\n" "$@"; }

