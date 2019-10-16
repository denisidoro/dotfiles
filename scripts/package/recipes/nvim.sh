#!/usr/bin/env bash
# vim: filetype=sh

nvim::install() {
   dot pkg add --no-custom neovim && exit 0 || true

   main_package_manager="$(platform::main_package_manager)"

   case $main_package_manager in
      brew)
         brew install neovim
         exit 0
         ;;
      yum)
         sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
         sudo yum install -y neovim python3-neovim
         exit 0
         ;;
   esac

   if platform::command_exists brew; then
      brew install neovim
      exit 0
   fi

   cd "$(fs::tmp)"
   curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
   chmod u+x nvim.appimage
   sudo mv nvim.appimage "$(fs::bin)/nvim"
}
