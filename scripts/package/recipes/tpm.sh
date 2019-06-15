#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

if fs::is_dir "$HOME/.tmux/plugins/tpm"; then
   recipe::abort_installed tpm
fi

git clone https://github.com/tmux-plugins/tpm --depth=1 $HOME/.tmux/plugins/tpm
