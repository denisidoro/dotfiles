#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed nvim

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

dot pkg add --package-manager neovim && recipe::abort_if_installed nvim

cd "$(fs::tmp)"
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage "$(fs::bin)/nvim"
