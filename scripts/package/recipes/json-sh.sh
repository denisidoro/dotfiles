#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

user="dominictarr"
repo="JSON.sh"
module="json-sh"

if recipe::has_submodule $module "JSON.sh"; then
	recipe::abort_installed $module
fi

recipe::clone_as_submodule $user $repo $module
