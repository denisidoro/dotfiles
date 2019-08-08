#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"
source "${DOTFILES}/scripts/package/aux/add.sh"

recipe::abort_if_installed ag

if [[ "$(recipe::main_package_manager)" = "brew" ]]; then
   brew install the_silver_searcher
   exit 0
fi

dot pkg add silversearcher-ag \
   || dot pkg add the_silver_searcher
