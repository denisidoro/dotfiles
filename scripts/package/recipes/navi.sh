#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed navi

if platform::command_exists brew; then
  brew install denisidoro/tools/navi
  exit 0
fi

git clone --depth 1 https://github.com/denisidoro/navi /opt/navi
cd /opt/navi
sudo make install 

dot pkg add fzf
