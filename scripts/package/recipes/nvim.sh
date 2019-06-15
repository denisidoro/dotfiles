#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

step::abort_if_installed nvim

if platform::command_exists brew; then
   brew install neovim
else
   cd "$HOME"
   sudo curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
   chmod u+x nvim.appimage
   sudo mv nvim.appimage /usr/local/nvim
fi