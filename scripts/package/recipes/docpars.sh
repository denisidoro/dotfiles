#!/usr/bin/env bash
set -euo pipefail

package::install() {
   has brew && brew install denisidoro/tools/docpars
}
