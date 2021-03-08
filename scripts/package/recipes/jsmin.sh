#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe jsmin && return 0 || true

   dot pkg add pipx
   pipx install jsmin
}
