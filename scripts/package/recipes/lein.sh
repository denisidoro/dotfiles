#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed lein

dot pkg add wget

folder="$(recipe::folder lein)"
mkdir -p "$folder" || true
cd "$folder"

url="https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein"
wget "$url" -O lein
chmod a+x lein
sudo mv lein "$(fs::bin)/lein"
