#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if dot pkg add --ignore-recipe navi; then 
      return 0
   fi

   if recipe::install_github_release denisidoro navi; then
      return 0
   fi

   recipe::cargo install navi
}
