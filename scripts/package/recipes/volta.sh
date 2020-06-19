#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe volta && return 0 || true

   dot pkg add curl
   curl https://get.volta.sh | bash
}
