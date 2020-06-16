#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   return 1
}

package::install() {
   cd "$DOTFILES"

   git submodule foreach git reset --hard || true
   git submodule foreach git checkout . || true
   git submodule foreach git pull origin master || true

   platform::command_exists zsh && dot pkg add zim

   return 0
}
