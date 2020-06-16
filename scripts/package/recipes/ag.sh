#!/usr/bin/env bash
set -euo pipefail

package::install() {
   platform::command_exists apt && dot pkg proxy apt add silversearcher-ag && return 0 || true
   platform::command_exists pkg && dot pkg proxy pkg add the_silver_searcher && return 0 || true
   platform::command_exists brew && brew install the_silver_searcher && return 0 || true
   recipe::install_from_git "https://github.com/ggreer/the_silver_searcher"
}