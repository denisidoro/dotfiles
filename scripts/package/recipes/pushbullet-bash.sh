#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

user="Red5d"
repo="pushbullet-bash"

if recipe::has_submodule $repo "pushbullet"; then
   recipe::abort_installed $repo
fi

recipe::clone_as_submodule $user $repo