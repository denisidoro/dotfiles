#!/usr/bin/env bash
# vim: filetype=sh

source "${DOTFILES}/scripts/package/aux/recipes.sh"

if fs::is_file "$HOME/.local/share/nvim/site/autoload/plug.vim"; then
   recipe::abort_installed "vimplug"
fi

curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
  http://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim