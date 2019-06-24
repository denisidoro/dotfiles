#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/add.sh"
source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed fzf

package_manager="$(platform::main_package_manager)"

if [[ $package_manager = "brew" ]]; then
   brew install fzf
   $(brew --prefix)/opt/fzf/install
   exit 0
fi

recipe::shallow_github_clone junegunn fzf
cd "$TEMP_FOLDER/fzf"
./install
