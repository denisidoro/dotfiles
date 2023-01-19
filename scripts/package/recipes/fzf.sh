#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if dot pkg add --ignore-recipe fzf; then 
      return 0
   fi

   if recipe::install_github_release junegunn fzf; then
      return 0
   fi

   dot pkg add fzf-latest
}
