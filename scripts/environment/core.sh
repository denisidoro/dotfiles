#!/usr/bin/env bash
# vim: filetype=sh

dotfiles_folder() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd
}

brew_install() {
  for repository in "$(deps::from "$@")"
  do
    brew install "$repository"
  done
}

cask_install() {
  for repository in "$(deps::from "$@")"
  do
    brew cask install "$repository"
  done
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