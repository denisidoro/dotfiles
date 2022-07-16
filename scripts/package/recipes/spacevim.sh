#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   cat "${HOME}/.config/nvim/init.vim" 2>/dev/null | grep -q "spacevim"
}

package::install() {
   dot pkg add curl
   dot pkg add nvim

   bash <(curl -fsSL https://raw.githubusercontent.com/liuchengxu/space-vim/master/install.sh)
}
