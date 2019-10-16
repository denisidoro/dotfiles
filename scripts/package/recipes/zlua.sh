#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

zlua::install() {
  install_from_git skywind3000 z.lua
}
