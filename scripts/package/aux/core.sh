#!/usr/bin/env bash

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
   local -r prevent_recipe="$2"

   if $prevent_recipe; then
      echo "$pkg"
      return 0
   fi

   case "$pkg" in
      fasd) echo "fre" ;;
      skim) echo "fzf" ;;
      leiningen) echo "lein" ;;
      ripgrep) echo "rg" ;;
      space-vim) echo "spacevim" ;;
      clj) echo "clojure" ;;
      vipe) echo "moreutils" ;;
      tldr) echo "tealdeer" ;;
      *) echo "$pkg" ;;
   esac
}