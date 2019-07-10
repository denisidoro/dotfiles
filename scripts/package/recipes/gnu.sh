#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

if ! platform::is_osx; then
   log::warning "No need to install gnu utils in a platform which is not OSX"
   exit 0
fi

recipe::abort_if_installed ggrep

brew tap homebrew/dupes
brew install binutils diffutils findutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gzip wget
brew install wdiff --with-gettext
brew install m4 make nano file-formula
