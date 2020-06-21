#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   has zsh && zsh -c 'source $HOME/.zshrc; zimfw help 2>/dev/null | grep -q Usage'
}

package::install() {
   dot pkg add curl
   dot pkg add zsh

   curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
}
