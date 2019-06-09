#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/pkg/aux/recipes.sh"

if platform::command_exists vifm; then
   exit 0
fi

dot pkg add libncursesw5-dev || true
step::shallow_github_clone vifm vifm
cd "$TEMP_FOLDER/vifm"
./scripts/fix-timestamps || true
./configure
step::make "vifm"
