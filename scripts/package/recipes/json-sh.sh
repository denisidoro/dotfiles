#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

user="dominictarr"
repo="JSON.sh"
cmd="json-sh"

if recipe::has_submodule $cmd "JSON.sh"; then
	recipe::abort_installed $cmd
fi

recipe::clone_as_submodule $user $repo $cmd
