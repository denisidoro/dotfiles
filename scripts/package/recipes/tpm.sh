#!/usr/bin/env bash
# vim: filetype=sh

tpm::is_installed() {
  fs::is_dir "$HOME/.tmux/plugins/tpm"
}

tpm::install() {
  git clone https://github.com/tmux-plugins/tpm --depth=1 $HOME/.tmux/plugins/tpm
}
