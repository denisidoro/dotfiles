#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe git-delta && return 0 || true

   dot pkg add cargo 
   cargo install git-delta
}
