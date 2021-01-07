#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe navi && return 0 || true

   has cargo && cargo install navi && return 0 || true

   dot pkg add curl
   bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
}
