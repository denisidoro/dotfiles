#!/usr/bin/env bash

function get_help_string() {
  grep "^##?" "$1" | cut -c 5-
}

function eval_opts() {
  local help="${1}"
  shift
  eval "$($DOTFILES/scripts/aux/docopts -h "${help}" : "${@}")"
}

function eval_docopts() {
  local help=$(get_help_string "$0")
  eval_opts "$help" "$@"
}

