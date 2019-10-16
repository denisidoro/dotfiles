#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

kitty::install() {
  install_from_git kovidgoyal kitty
}
