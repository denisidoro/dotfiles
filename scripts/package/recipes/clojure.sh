#!/usr/bin/env bash
# vim: filetype=sh

clojure::install() {
   platform::is_osx && brew install clojure && return 0

   local -r CLJ_VERSION="1.10.1.447"
   local -r CLJ_FOLDER="$TMP_DIR/clojure"

   pushd
   mkdir -p "$CLJ_FOLDER" || true
   cd "$CLJ_FOLDER"
   curl -O "https://download.clojure.org/install/linux-install-${CLJ_VERSION}.sh"
   chmod +x "linux-install-${CLJ_VERSION}.sh"
   sudo "./linux-install-${CLJ_VERSION}.sh"
   popd
   rm -rf "$CLJ_VERSION"
}