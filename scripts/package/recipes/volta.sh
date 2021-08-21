#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if dot pkg add --prevent-recipe volta; then return 0; fi

   dot pkg add curl
   curl https://get.volta.sh | bash
}
