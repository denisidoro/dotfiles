#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add zsh
   has brew && brew install starship && return 0 || true

   dot pkg add curl
   bash <(curl -fsSL https://starship.rs/install.sh)
}
