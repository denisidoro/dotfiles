#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

user="jasperes"
repo="bash-yaml"

if recipe::has_submodule $repo; then
	step::abort_installed $repo
fi

recipe::clone_as_submodule $user $repo