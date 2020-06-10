#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

package::install() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}