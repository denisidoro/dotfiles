#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES}/scripts/core/platform.sh"

package::install() {
   dot pkg add neovim && return 0 || true
   dot pkg add --prevent-recipe nvim && return 0 || true

   dot pkg add curl
   cd "$(platform::get_tmp_dir)"
   curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
   chmod u+x nvim.appimage
   sudo mv nvim.appimage "$(platform::get_bin_dir)/nvim"
}
