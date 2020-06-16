#!/usr/bin/env bash
set -euo pipefail

package::install() {
   platform::command_exists brew && brew install borkdude/brew/jet && return 0 || true

   dot pkg add curl
   bash <(curl -s https://raw.githubusercontent.com/borkdude/jet/master/install)
}