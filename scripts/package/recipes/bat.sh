#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

VERSION="0.11.0"

url::generate() {
   local -r suffix="$1"
   echo "https://github.com/sharkdp/bat/releases/download/v${VERSION}/bat_${VERSION}_${suffix}.deb"
}

url::get() {
   local -r tags="$(platform::tags)"
   local suffix
   case $tags in
      *arm*) suffix="arm64" ;;
      *64bits*) suffix="amd64" ;;
      *) suffix="i386" ;;
   esac
   url::generate "$suffix"
}

bat::depends_on() {
   dot pkg add wget
}

bat::install() {
   dot pkg add --no-custom bat && return 0 || true

   folder="$(recipe::folder bat)"
   mkdir -p "$folder" || true
   cd "$folder"

   url="$(url::get)"
   wget "$url" -O bat
   sudo dpkg -i bat
}
