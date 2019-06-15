#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

user="denisidoro"
repo="docoptsh"

if recipe::has_submodule $repo "docoptsh"; then
	recipe::abort_installed $repo
fi

recipe::clone_as_submodule $user $repo
