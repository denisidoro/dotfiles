#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if has brew && brew install borkdude/brew/jet; then return 0; fi

   dot pkg add curl
   bash <(curl -s https://raw.githubusercontent.com/borkdude/jet/master/install)
}