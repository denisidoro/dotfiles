#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if has brew && brew install denisidoro/tools/docpars; then return 0; fi
   recipe::cargo docpars
}
