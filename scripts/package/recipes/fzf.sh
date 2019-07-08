#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/add.sh"
source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed fzf

package_manager="$(platform::main_package_manager)"

case $package_manager in
   brew)
      brew install fzf
      $(brew --prefix)/opt/fzf/install
      exit 0
      ;;
   pkg)
      dot pkg add --package-manager fzf
      exit 0
      ;;
esac

recipe::shallow_github_clone junegunn fzf
cd "$TMP_DIR/fzf"
./install
