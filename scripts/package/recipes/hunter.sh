#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add cargo
   cargo +nightly install --no-default-features hunter
}