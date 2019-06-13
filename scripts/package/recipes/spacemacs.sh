#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

if ls ~/.emacs.d/ | grep -q spacemacs || false; then
   git clone https://github.com/syl20bnr/spacemacs --depth 1 ~/.emacs.d
fi
