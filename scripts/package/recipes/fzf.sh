#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed fzf

pm="$(recipe::main_package_manager)"

if [[ $pm = "brew" ]]; then
	brew install fzf
	$(brew --prefix)/opt/fzf/install
	exit 0
esac

recipe::shallow_github_clone junegunn fzf
cd "$TEMP_FOLDER/fzf"
./install
