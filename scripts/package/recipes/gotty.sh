#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

REPO_TAG="2.0.0-alpha.3"

url::generate() {
   local -r suffix="$1"
   echo "https://github.com/yudai/gotty/releases/download/v${REPO_TAG}/gotty_${REPO_TAG}_${suffix}.tar.gz"
}

url::get() {
   local -r tags="$(platform::tags)"
   local suffix
   case $tags in
      *osx*64bits*) suffix="darwin_386" ;;
      *64bits*osx*) suffix="darwin_386" ;;
      *osx*) suffix="darwin_amd64" ;;
      *arm*) suffix="linux_arm" ;;
      *64bits*) suffix="linux_amd64" ;;
      *) suffix="linux_386" ;;
   esac
   url::generate "$suffix"
}

recipe::abort_if_installed "gotty"

if platform::command_exists brew; then
   brew install yudai/gotty/gotty
   exit 0
fi

dot pkg add wget

folder="$(recipe::folder gotty)"
mkdir -p "$folder" || true
cd "$folder"

url="$(url::get)"
wget "$url" -O gotty.tar.gz

tar -zxvf gotty.tar.gz
sudo mv "./gotty" "$(fs::bin)/gotty"
