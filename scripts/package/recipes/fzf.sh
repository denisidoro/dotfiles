#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if dot pkg add --prevent-recipe fzf; then return 0; fi

   dot pkg add git
   recipe::shallow_github_clone junegunn fzf # TODO
   cd "$TMP_DIR/fzf"

   yes | ./install
}
