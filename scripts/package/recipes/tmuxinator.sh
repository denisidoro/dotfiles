#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

if ! platform::command_exists tmuxinator; then
   gem install tmuxinator
fi
