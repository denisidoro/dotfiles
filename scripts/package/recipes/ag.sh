#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

if platform::command_exists ag; then
   exit 0
fi

if platform::command_exists apt-get; then 
   sudo apt-get install silversearcher-ag
elif platform::command_exists brew; then 
   brew install the_silver_searcher
else
   dot pkg add the_silver_searcher \
      || dot pkg add silversearcher-ag \
      || dot pkg add the_silver_searcher
fi