#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

if cat "$HOME/.config/nvim/init.vim" 2>/dev/null | grep -q "space-vim" 2>/dev/null; then
   recipe::abort_installed spacevim
fi

dot pkg add curl nvim
bash <(curl -fsSL https://raw.githubusercontent.com/liuchengxu/space-vim/master/install.sh)
