#!/usr/bin/env bash
 
package::is_installed() {
   [ -f "${DOTFILES}/target/dotrs" ]
}

package::install() {
   cd "${DOTFILES}/rust"

   if platform::command_exists cargo; then
      dot rust binary build
      dot rust binary symlink
   else
      BIN_DIR="${DOTFILES}/target" dot rust binary download
   fi
}