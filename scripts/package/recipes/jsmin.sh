#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe jsmin && return 0 || true

   dot pkg add pip && pip install jsmin && return 0 || true
   dot pkg add pip3 && pip3 install jsmin
}
