#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

package::install() {
    platform::command_exists brew && brew install starship && return 0 || true

    curl -fsSL https://starship.rs/install.sh | bash
}
