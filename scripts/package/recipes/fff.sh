#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed fff

recipe::shallow_github_clone dylanaraps fff
recipe::make fff
