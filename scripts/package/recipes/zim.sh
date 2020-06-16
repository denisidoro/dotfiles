#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   return 1
}

package::install() {
      export ZIM_HOME="${ZIM_HOME:-$DOTFILES/modules/zimfw}"
      zsh "$ZIM_HOME/zimfw.zsh" upgrade
      rm -rf "$ZIM_HOME/modules/"* && zsh "$ZIM_HOME/zimfw.zsh" install
}
