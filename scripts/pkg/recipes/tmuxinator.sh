#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/pkg/aux/recipes.sh"

if ! platform::command_exists tmuxinator; then
   gem install tmuxinator
fi
