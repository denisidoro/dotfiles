#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES}/scripts/core/platform.sh"

package::install() {
   platform::is_osx || return 1
   xcode-select --install
}