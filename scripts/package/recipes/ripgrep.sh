#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   has rg
}

package::install() {
   dot pkg add --prevent-recipe ripgrep
}
