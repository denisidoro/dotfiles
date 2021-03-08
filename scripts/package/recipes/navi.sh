#!/usr/bin/env bash
set -euo pipefail

package::install() {
   recipe::cargo navi && return 0 || true

   dot pkg add curl
   bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
}
