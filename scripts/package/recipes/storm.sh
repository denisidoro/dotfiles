#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if recipe::install_github_release denisidoro storm; then
      return 0
   fi
   
   recipe::cargo install --git https://github.com/denisidoro/storm
}
