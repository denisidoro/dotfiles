#!/usr/bin/env bash

function eval_docopts() {
  local file="$0"
  local help=$(grep "^##?" "$file" | cut -c 5-)
  local version_code=$(grep "^ #?"  "$file" | cut -c 5-)
  local git_info=$(cd "$DOTFILES"; git log -n 1 --pretty=format:'%h%n%ad%n%an%n%s' --date=format:'%Y-%m-%d %Hh%M' -- "$file")
  local version="$(echo -e "${version_code}\n${git_info}")"
  eval "$($DOTFILES/scripts/core/docopts -h "${help}" -V "${version}" : "${@}")"
}

