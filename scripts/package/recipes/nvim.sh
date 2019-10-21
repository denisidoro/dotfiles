#!/usr/bin/env bash
# vim: filetype=sh

nvim::map() {
   dict::new brew neovim
}

nvim::yum() {
   sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
   sudo yum install -y neovim python3-neovim
}

nvim::install() {
   cd "$(fs::tmp)"
   curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
   chmod u+x nvim.appimage
   sudo mv nvim.appimage "$(fs::bin)/nvim"
}
