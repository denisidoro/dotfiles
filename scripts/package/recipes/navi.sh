#!/usr/bin/env bash
set -euo pipefail

package::install() {
   has brew && brew install navi && return 0 || true

   dot pkg add curl
   bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
}
