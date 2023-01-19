#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if dot pkg add --ignore-recipe exa; then 
      return 0
   fi

   if recipe::install_github_release ogham exa; then
      return 0
   fi

   recipe::cargo install exa
}