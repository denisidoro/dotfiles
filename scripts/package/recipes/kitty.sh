#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

step::abort_if_installed kitty

step::shallow_github_clone kovidgoyal kitty
step::make kitty
