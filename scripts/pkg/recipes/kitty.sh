#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/pkg/aux/recipes.sh"

if ! platform::command_exists kitty; then
   step::shallow_github_clone kovidgoyal kitty
   step::make kitty
fi