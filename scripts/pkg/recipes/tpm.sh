#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/pkg/aux/recipes.sh"

if ! fs::is_dir "$HOME/.tmux/plugins/tpm"; then
   git clone https://github.com/tmux-plugins/tpm --depth=1 $HOME/.tmux/plugins/tpm
fi
