#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   return 1
}

_mkdir() {
   mkdir -p "$@" 2>/dev/null || true
}

package::install() {
   _mkdir "${DOTFILES}/local/${DOT_INSTANCE}/tmp"
   _mkdir "${DOTFILES}/local/${DOT_INSTANCE}/bin"
   _mkdir "${DOTFILES}/target"
   _mkdir "${DOTFILES}/bin"

   _mkdir "$(platform::get_tmp_dir)"
   _mkdir "$(platform::get_bin_dir)"
}
