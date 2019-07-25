#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed clojure

dot pkg add --package-manager clojure \
   && recipe::abort_if_installed clojure \
   || true

CLJ_VERSION="1.10.1.447"
CLJ_FOLDER="$TMP_DIR/clojure"

pushd
mkdir -p "$CLJ_FOLDER" || true
cd "$CLJ_FOLDER"
curl -O "https://download.clojure.org/install/linux-install-${CLJ_VERSION}.sh"
chmod +x "linux-install-${CLJ_VERSION}.sh"
sudo "./linux-install-${CLJ_VERSION}.sh"
popd
rm -rf "$CLJ_VERSION"