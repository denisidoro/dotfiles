#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe fzf && return 0 || true

   dot pkg add git
   recipe::shallow_github_clone junegunn fzf # TODO
   cd "$TMP_DIR/fzf"

   yes | ./install
}
