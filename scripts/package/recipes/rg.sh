#!/usr/bin/env bash
set -euo pipefail

package::install() {
   recipe::cargo ripgrep && return 0 || true
   recipe::cargo rg
}
