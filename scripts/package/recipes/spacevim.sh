#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

cat "$HOME/.config/nvim/init.vim" 2>/dev/null \
   | grep -q "space-vim" 2>/dev/null \
   || bash <(curl -fsSL https://raw.githubusercontent.com/liuchengxu/space-vim/master/install.sh)
