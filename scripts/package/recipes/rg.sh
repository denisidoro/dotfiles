#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if recipe::cargo ripgrep; then return 0; fi
   recipe::cargo rg
}
