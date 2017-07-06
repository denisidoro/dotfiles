#!/usr/bin/env bash
# vim: filetype=sh

dotfiles_folder() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd
}

brew_install() {
  for repository in "$(from_dependencies "$@")"
  do
    brew install "$repository"
  done
}

cask_install() {
  for repository in "$(from_dependencies "$@")"
  do
    brew cask install "$repository"
  done
}

