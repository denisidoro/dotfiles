#!/usr/bin/env bash
set -euo pipefail

package::install() {
   has brew && brew install camdencheek/brew/fre && return 0 || true
   recipe::cargo fre
}