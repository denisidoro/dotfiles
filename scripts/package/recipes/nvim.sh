#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if dot pkg add --ignore-recipe neovim; then return 0; fi
   if dot pkg add --ignore-recipe nvim; then return 0; fi

   dot pkg add curl
   cd "$(platform::get_tmp_dir)"
   curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
   chmod u+x nvim.appimage
   sudo mv nvim.appimage "$(platform::get_bin_dir)/nvim"
}
