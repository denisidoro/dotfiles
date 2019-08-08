#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed lua

main_package_manager="$(platform::main_package_manager)"

if [[ $main_package_manager = "apt" ]]; then
  VERSION=${VERSION:-5.3}
  luacmd="lua${VERSION}"
  dot pkg add --package-manager "$luacmd"
  sudo mv "$luacmd" "$(fs::bin)/lua"
  exit 0
fi

dot pkg add --package-manager lua
