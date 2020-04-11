#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

package::is_installed() {
   cat "$HOME/.config/nvim/init.vim" 2>/dev/null | grep -q "space-vim" 2>/dev/null
}

package::install() {
   dot pkg add nvim
   bash <(curl -fsSL https://raw.githubusercontent.com/liuchengxu/space-vim/master/install.sh)
}
