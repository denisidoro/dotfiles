#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

step::abort_if_installed colorls

gem install colorls \
   || sudo gem install colorls