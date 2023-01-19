#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if dot pkg add --ignore-recipe git-delta; then 
      return 0
   fi

   if recipe::install_github_release dandavison delta; then
      return 0
   fi

   recipe::cargo install git-delta
}
