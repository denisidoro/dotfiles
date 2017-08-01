#!/usr/bin/env bash

function extract_help() {
  local file="$1"
  grep "^##?" "$file" | cut -c 5-
}

function eval_docopts() {
  local file="$0"
  local help=$(extract_help "$file")
  local version_code=$(grep "^ #?"  "$file" | cut -c 5- || echo "0.0.0")
  local git_info=$(cd "$DOTFILES"; git log -n 1 --pretty=format:'%h%n%ad%n%s' --date=format:'%Y-%m-%d %Hh%M' -- "$file")
  local version="$(echo -e "${version_code}\n${git_info}")"
  eval "$($DOTFILES/scripts/core/docopts -h "${help}" -V "${version}" : "${@}")"
}

