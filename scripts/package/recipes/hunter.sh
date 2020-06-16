#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add rustup
   cargo +nightly install --no-default-features hunter
}