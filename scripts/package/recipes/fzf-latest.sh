#!/usr/bin/env bash
set -euo pipefail

package::install() {
   local -r folder="$(recipe::shallow_github_clone junegunn fzf)"
   cd "$folder" || exit
   recipe::install
}
