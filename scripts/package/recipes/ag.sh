#!/usr/bin/env bash
set -euo pipefail

package::install() {
   has apt && dot pkg proxy apt add silversearcher-ag && return 0 || true
   has pkg && dot pkg proxy pkg add the_silver_searcher && return 0 || true
   has brew && brew install the_silver_searcher && return 0 || true

   dot pkg add git
   recipe::install_from_git "ggreer/the_silver_searcher"
}