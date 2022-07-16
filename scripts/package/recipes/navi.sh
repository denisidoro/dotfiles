#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if recipe::cargo navi; then 
      return 0; 
   fi

   recipe::check_if_can_build
   dot pkg add curl
   bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
}
