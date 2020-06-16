#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

package::is_installed() {
   return 1
}

package::install() {
      cd "$DOTFILES"

      git submodule foreach git reset --hard
      git submodule foreach git checkout .
      git submodule foreach git pull origin master

      platform::command_exists zsh && dot pkg add zim

      return 0
}
