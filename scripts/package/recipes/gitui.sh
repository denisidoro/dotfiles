#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if dot pkg add --prevent-recipe gitui; then return 0; fi

   dot pkg add cargo
   cargo install gitui
}
