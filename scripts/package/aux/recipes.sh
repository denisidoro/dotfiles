#!/usr/bin/env bash
# vim: filetype=sh

source "${DOTFILES}/scripts/core/main.sh"

TEMP_FOLDER="${HOME}/tmp"

step::shallow_github_clone() {
   local readonly user="$1" 
   local readonly repo="$2"
   mkdir -p "$TEMP_FOLDER"
   git clone "https://github.com/${user}/${repo}" --depth 1 "${TEMP_FOLDER}/${repo}" || true
}

step::make() {
   local repo="$1"
   cd "${TEMP_FOLDER}/${repo}"
   make && sudo make install
}
