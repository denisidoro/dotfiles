#!/usr/bin/env bash
 
package::install() {
   dot pkg add --prevent-recipe fzf && return 0 || true
   recipe::shallow_github_clone junegunn fzf
   cd "$TMP_DIR/fzf"
   yes | ./install
}
