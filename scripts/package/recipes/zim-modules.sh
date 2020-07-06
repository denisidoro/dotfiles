#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   return 1
}

package::install() {
   dot pkg add zim

zsh -c 'source $HOME/.zshrc; zimfw install'
}
