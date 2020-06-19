#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add curl
   bash <(curl -sL https://raw.githubusercontent.com/denisidoro/fre/master/scripts/install)
}