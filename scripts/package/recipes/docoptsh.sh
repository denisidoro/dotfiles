#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

user="denisidoro"
repo="docoptsh"

_get_awk_version() {
   awk -Wversion 2> /dev/null \
      || awk --version
}

if recipe::has_submodule $repo "docoptsh"; then
	recipe::abort_installed $repo
fi

if _get_awk_version | head -n1 | grep -q mawk 2> /dev/null; then
   dot pkg add gawk || true
fi

recipe::clone_as_submodule $user $repo
