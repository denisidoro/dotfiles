#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add vim
   local -r vim="$(which vim)"
   local -r vi="$(echo "$vim" | sed 's/vim/vi/')"
   sudo ln -s "$vim" "$vi"
}
