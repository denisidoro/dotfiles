#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

package::install() {
    dot apk add rustup
    cargo +nightly install --no-default-features hunter
}