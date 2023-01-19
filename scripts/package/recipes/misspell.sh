#!/usr/bin/env bash
set -euo pipefail

package::install() {
   local -r folder="$(mktemp -d)"
   cd "$folder"
   echoerr "$folder"
   curl -L -o ./install-misspell.sh https://git.io/misspell
   sh ./install-misspell.sh
   mv ./bin/misspell /usr/local/bin/misspell
}