#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe leiningen \
      || dot pkg add --prevent-recipe lein \
      && return 0 \
      || true

   dot pkg add wget

   folder="$(recipe::folder lein)"
   mkdir -p "$folder" || true
   cd "$folder"

   url="https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein"
   wget "$url" -O lein
   chmod a+x lein
   sudo mv lein "$(fs::bin)/lein"
}