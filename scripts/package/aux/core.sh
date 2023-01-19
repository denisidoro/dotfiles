#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/main.sh"
source "${DOTFILES}/scripts/core/platform.sh"

ALIASES_TXT="${DOTFILES}/scripts/package/aux/aliases.txt"

_dashed_package() {
   local -r package="$1"
   echo "$package" | tr ' _' '-'
}

pkg::source_file() {
   local -r package="$1"
   local -r dashed_package="$(_dashed_package "$package")"
   echo "${DOTFILES}/scripts/package/recipes/${dashed_package}.sh"
}

pkg::alias() {
   local -r pkg="$1"
   local -r ignore_recipe="$2"

   if $ignore_recipe; then
      echo "$pkg"
      return 0
   fi

   local -r other_name="$(cat "$ALIASES_TXT" | grep "$pkg" | head -n1 | awk '{print $2}')"

   if [ -n "$other_name" ]; then
      echo "$other_name"
   else
      echo "$pkg"
   fi
}