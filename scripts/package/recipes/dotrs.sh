#!/usr/bin/env bash
# vim: filetype=sh

package::is_installed() {
   [ -f "${DOTFILES}/rust/target/tar/dot" ]
}

package::install() {
    export PROJ_NAME="dot"
    export PROJ_HOME="${DOTFILES}/rust"

   cd "${DOTFILES}/rust"
   dot rust action release
}