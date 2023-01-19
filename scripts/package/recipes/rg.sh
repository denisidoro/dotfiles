#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if dot pkg add --ignore-recipe ripgrep; then 
      return 0
   fi

   if recipe::install_github_release BurntSushi ripgrep; then
      return 0
   fi

   recipe::cargo install ripgrep
}
