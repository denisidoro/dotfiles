#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if has apt && dot pkg proxy apt add silversearcher-ag; then return 0; fi
   if has brew && brew install the_silver_searcher; then return 0; fi
   if has pkg && dot pkg proxy pkg add the_silver_searcher; then return 0; fi

   dot pkg add git
   recipe::install_from_git "ggreer/the_silver_searcher"
}