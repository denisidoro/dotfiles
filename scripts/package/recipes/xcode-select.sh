#!/usr/bin/env bash
set -euo pipefail

package::install() {
   platform::is_osx || return 0
   xcode-select --install
}