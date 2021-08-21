#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if has brew && brew install camdencheek/brew/fre; then return 0; fi
   recipe::cargo fre
}