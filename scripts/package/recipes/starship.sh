#!/usr/bin/env bash
set -euo pipefail

package::install() {
   platform::command_exists brew && brew install starship && return 0 || true

   dot pkg add curl
   bash <(curl -fsSL https://starship.rs/install.sh)
}
