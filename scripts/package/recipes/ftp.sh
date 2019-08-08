#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed ftp

main_package_manager="$(platform::main_package_manager)"

case $main_package_manager in
   brew)
      brew install inetutils
      exit 0
      ;;
esac

dot pkg add --package-manager ftp

