#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/pkg/aux/recipes.sh"

if platform::command_exists fff; then
   exit 0
fi

step::shallow_github_clone dylanaraps fff
step::make fff
