#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

tpm::is_installed() {
  fs::is_dir "$HOME/.tmux/plugins/tpm"
}

tpm::install() {
  git clone https://github.com/tmux-plugins/tpm --depth=1 $HOME/.tmux/plugins/tpm
}
