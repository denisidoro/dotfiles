#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if dot pkg add --ignore-recipe jsmin; then return 0; fi

   dot pkg add pipx
   pipx install jsmin
}
