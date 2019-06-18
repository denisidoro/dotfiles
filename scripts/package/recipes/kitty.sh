#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed kitty

recipe::shallow_github_clone kovidgoyal kitty
recipe::make kitty
