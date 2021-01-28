#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   return 1
}

_mkdir() {
   mkdir -p "$@" 2>/dev/null || true
}

package::install() {
   _mkdir "${DOTFILES}/local"
   _mkdir "${DOTFILES}/local/tmp"
   _mkdir "${DOTFILES}/local/bin"
   _mkdir "${DOTFILES}/target"
   _mkdir "${DOTFILES}/bin"

   _mkdir "$(platform::get_tmp_dir)"
   _mkdir "$(platform::get_bin_dir)"
}
