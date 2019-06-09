#!/usr/bin/env bash
# vim: filetype=sh

TEMP_FOLDER="${HOME}/tmp"

brew_install() {
   brew install "$@"
}

cask_install() {
    brew cask install "$@"
}

shallow_github_clone() {
   local readonly user="$1" 
   local readonly repo="$2"
   mkdir -p "$TEMP_FOLDER"
   git clone "https://github.com/${user}/${repo}" --depth 1 "${TEMP_FOLDER}/${repo}"
}

tmp_make() {
   local repo="$1"
   cd "${TEMP_FOLDER}/${repo}"
   make && sudo make install
}

deps::read() {
   local file
   file=$(rsrc "environment/aux/dependencies.txt")
   echo "$(cat "$file")\n\n"
}

deps::from() {
   for key in "$@"; do
     deps::read | grep -Pzo "\[$key\]\s+(.|\n)*?($|\n{2})" | tail -n +2 | sed '/^$/d'
   done
}
