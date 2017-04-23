#!/usr/bin/env bash

function eval_docopts() {
  local file="$0"
  local help=$(grep "^##?" "$file" | cut -c 5-)
  local version=$(grep "^ #?"  "$file" | cut -c 5-)
  eval "$($DOTFILES/scripts/core/docopts -h "${help}" -V "${version}" : "${@}")"
}

