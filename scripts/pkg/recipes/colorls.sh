#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/pkg/aux/recipes.sh"

if platform::command_exists colorls; then
   exit 0
fi

gem install colorls \
   || sudo gem install colorls
