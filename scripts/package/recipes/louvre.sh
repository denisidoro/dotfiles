#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if recipe::install_github_release denisidoro louvre; then
      return 0
   fi
   
   recipe::cargo install --git https://github.com/denisidoro/louvre
}
