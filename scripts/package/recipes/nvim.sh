#!/usr/bin/env bash
# vim: filetype=sh

package::install() {
   (dot pkg add neovim || dot pkg add nvim) && return 0

   dot pkg add curl
   cd "$(fs::tmp)"
   curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
   chmod u+x nvim.appimage
   sudo mv nvim.appimage "$(fs::bin)/nvim"
}
