#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   has tldr
}

package::install() {
   if dot pkg add --ignore-recipe tealdeer; then 
      return 0
   fi

   if recipe::install_github_release dbrgn tealdeer; then
      return 0
   fi

   recipe::cargo install tealdeer
}
