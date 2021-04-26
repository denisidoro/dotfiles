#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe gitui && return 0 || true

   dot pkg add cargo
   cargo install gitui
}
