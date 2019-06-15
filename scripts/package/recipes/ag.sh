#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

step::abort_if_installed ag

case "$(step::main_package_manager)" in
	apt) sudo apt-get install silversearcher-ag && exit 0;;
	brew) brew install the_silver_searcher && exit 0;;
esac

dot pkg add the_silver_searcher \
   || dot pkg add silversearcher-ag \
   || dot pkg add the_silver_searcher
