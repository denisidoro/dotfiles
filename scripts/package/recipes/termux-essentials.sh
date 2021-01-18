#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES}/scripts/core/fs.sh"
source "${DOTFILES}/scripts/core/platform.sh"

package::is_installed() {
   return 1
}

package::install() {
   platform::is_android || return 1

   pkg install ncurses-utils || true
   pkg install proot || true
   pkg install unstable-repo || true
   apt install coreutils || true
   pkg install util-linux || true
   pkg install termux-packages || true
   pkg install grep || true
   pkg install sed || true
   termux-setup-storage || true
   termux-chroot || true

   dot pkg add termux-tudo termux-sudo
}
