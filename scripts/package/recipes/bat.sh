#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

VERSION="0.11.0"

url::generate() {
   local readonly suffix="$1"
   echo "https://github.com/sharkdp/bat/releases/download/v${VERSION}/bat_${VERSION}_${suffix}.deb"
}

url::get() {
   local readonly tags="$(platform::tags)"
   local suffix
   case $tags in
      *arm*) suffix="arm64";;
      *64bits*) suffix="amd64";;
      *) suffix="i386";;
   esac
   url::generate "$suffix"
}

recipe::abort_if_installed bat

dot pkg add --package-manager bat && recipe::abort_if_installed bat

dot pkg add wget

folder="$(recipe::folder bat)"
mkdir -p "$folder" || true
cd "$folder"

url="$(url::get)"
wget "$url" --output-document bat
sudo dpkg -i bat
