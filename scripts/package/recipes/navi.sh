#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if recipe::cargo navi; then return 0; fi

   dot pkg add curl
   bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
}
