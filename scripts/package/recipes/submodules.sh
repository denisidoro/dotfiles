#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   return 1
}

package::install() {
   dot pkg add git

   cd "$DOTFILES"

   git submodule foreach git reset --hard || true
   git submodule foreach git checkout . || true
   git submodule foreach git pull origin master || true

   return 0
}
