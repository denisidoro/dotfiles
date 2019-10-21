#!/usr/bin/env bash
# vim: filetype=sh

vimplug::is_installed() {
   fs::is_file "$HOME/.local/share/nvim/site/autoload/plug.vim"
}

vimplug::install() {
   curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
      http://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}