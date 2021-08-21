#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add neovim
   local -r nvim="$(which nvim)"
   local -r vim="${nvim//nvim/vim}"
   sudo ln -s "$nvim" "$vim"
}
