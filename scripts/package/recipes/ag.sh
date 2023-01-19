#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if has apt && dot pkg proxy apt add silversearcher-ag; then return 0; fi
   if has brew && brew install the_silver_searcher; then return 0; fi
   if has pkg && dot pkg proxy pkg add the_silver_searcher; then return 0; fi

   local -r folder="$(recipe::shallow_github_clone ggreer the_silver_searcher)"
   cd "$folder" || exit
   recipe::install
}