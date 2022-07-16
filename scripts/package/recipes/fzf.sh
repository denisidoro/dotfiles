#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if dot pkg add --prevent-recipe fzf; then 
      return 0
   fi

   recipe::check_if_can_build
   dot pkg add git
   recipe::shallow_github_clone junegunn fzf # TODO
   cd "$TMP_DIR/fzf"
   yes | ./install
}
