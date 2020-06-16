#!/usr/bin/env bash
 
package::install() {
   dot pkg add neovim && return 0 || true
   dot pkg add --prevent-recipe nvim && return 0 || true

   dot pkg add curl
   cd "$(fs::tmp)"
   curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
   chmod u+x nvim.appimage
   sudo mv nvim.appimage "$(fs::bin)/nvim"
}
