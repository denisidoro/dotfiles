#!/usr/bin/env bash
# vim: filetype=sh

dotfiles_folder() {
   cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd
}

brew_install() {
   brew install "$@"
}

cask_install() {
    brew cask install "$@"
}

shallow_github_clone() {
   local user="$1" repo="$2"
   mkdir -p "$HOME/tmp"
   git clone "https://github.com/${user}/${repo}" --depth 1 "$HOME/tmp/${repo}"
}

tmp_make() {
   local repo="$1"
   cd "$HOME/tmp/${repo}"
   make && sudo make install
}

function deps::read() {
   local file
   file=$(rsrc "environment/dependencies.txt")
   echo "$(cat "$file")\n\n"
}

function deps::from() {
   for key in "$@"; do
     deps::read | grep -Pzo "\[$key\]\s+(.|\n)*?($|\n{2})" | tail -n +2 | sed '/^$/d'
   done
}
