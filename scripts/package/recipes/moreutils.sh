#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   has vipe
}

package::install() {
   dot pkg add --ignore-recipe moreutils
}
