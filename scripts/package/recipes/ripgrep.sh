#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

package::is_installed() {
      platform::command_exists rg
}

package::install() {
    dot pkg add --prevent-recipe ripgrep
}
