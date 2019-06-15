#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

step::abort_installed vifm

dot pkg add libncurses5-dev || true
dot pkg add libncursesw5-dev || true

step::shallow_github_clone vifm vifm
cd "$TEMP_FOLDER/vifm"
./scripts/fix-timestamps || true
./configure
step::make "vifm"
