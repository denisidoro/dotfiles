#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   [ -f "${DOTFILES}/target/dotrs" ]
}

package::install() {
   cd "${DOTFILES}/rust"

   if has cargo; then
      dot rust binary build
      dot rust binary symlink
   else
      BIN_DIR="${DOTFILES}/target" dot rust binary download
   fi
}