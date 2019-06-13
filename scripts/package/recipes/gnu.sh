#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

if ! platform::command_exists ggrep; then
   brew tap homebrew/dupes
   brew install binutils diffutils ed findutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gzip screen watch wget && brew install wdiff --with-gettext
   brew install bash m4 make nano file-formula git less openssh rsync unzip
fi