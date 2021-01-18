#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   has sudo
}

package::install() {
    local -r termux_bin_path="/data/data/com.termux/files/usr/bin"
    local -r sudo_bin="${termux_bin_path}/sudo"

    curl -L 'https://github.com/agnostic-apollo/sudo/releases/latest/download/sudo' -o "$sudo_bin"

    local -r owner="$(stat -c "%u" "$termux_bin_path")"

    chown "${owner}:${owner}" "$sudo_bin"
    chmod 700 "$sudo_bin";
}
