#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

dot pkg add lua

user="kywind3000"
repo="z.lua"

if recipe::has_submodule $repo "z.lua"; then
   recipe::abort_installed $repo
fi

recipe::clone_as_submodule $user $repo
