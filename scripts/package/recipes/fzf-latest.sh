#!/usr/bin/env bash
set -euo pipefail

package::install() {
   recipe::shallow_github_clone junegunn fzf # TODO
   cd "$TMP_DIR/fzf"
   yes | ./install
}
