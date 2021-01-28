#!/usr/bin/env bash
set -euo pipefail

package::install() {
   platform::is_osx || return 1
   xcode-select --install
}