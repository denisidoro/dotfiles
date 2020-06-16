#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add neovim
   local -r nvim="$(which nvim)" 
   sudo ln -s "$nvim" "$(echo "$nvim" | sed 's/nvim/vim/'ß)"
}
