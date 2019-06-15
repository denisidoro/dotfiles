#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

step::abort_if_installed clojure

pm="$(step::main_package_manager)"

if [[ $pm = "brew" ]]; then
	brew install clojure
esac

CLJ_VERSION="1.10.1.447"
CLJ_FOLDER="$TEMP_FOLDER/clojure"

pushd
mkdir -p "$CLJ_FOLDER" || true
cd "$CLJ_FOLDER"
curl -O "https://download.clojure.org/install/linux-install-${CLJ_VERSION}.sh"
chmod +x "linux-install-${CLJ_VERSION}.sh"
sudo "./linux-install-${CLJ_VERSION}.sh"
popd
rm -rf "$CLJ_VERSION"