#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   return 1
}

package::install() {
   dot pkg add curl
   dot pkg add zsh

   curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh	
}
