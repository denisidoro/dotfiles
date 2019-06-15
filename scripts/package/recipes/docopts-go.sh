#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

REPO_TAG="v0.6.3-alpha1"

url::generate() {
   local readonly suffix="$1"
   echo "https://github.com/denisidoro/docopts/releases/download/${REPO_TAG}/docopts-${suffix}"
}

url::get() {
   local readonly tags="$(platform::tags)"
   local suffix
   case $tags in
      *osx*) suffix="osx";;
      *arm*) suffix="linux-arm";;
      *64bits*) suffix="linux-x86_64";;
      *) suffix="linux-x86";;
   esac
   url::generate "$suffix"
}

if docopts --version 2> /dev/null | grep -q golang; then
   step::abort_installed "docopts-go"
fi

folder="$(recipe::folder docopts-go)"
mkdir -p "$folder" || true
cd "$folder"

url="$(url::get)"
wget "$url" --output-document docopts

sudo chmod +x "${folder}/docopts"
sudo mv "${folder}/docopts" "/usr/local/bin/docopts"
