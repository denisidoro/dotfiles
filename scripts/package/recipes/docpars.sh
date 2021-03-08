#!/usr/bin/env bash
set -euo pipefail

package::install() {
   has brew && brew install denisidoro/tools/docpars && return 0 || true
   recipe::cargo docpars
}
