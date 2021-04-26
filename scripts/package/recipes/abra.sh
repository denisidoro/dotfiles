#!/usr/bin/env bash
set -euo pipefail

package::install() {
   has brew && brew install denisidoro/tools/abra && return 0 || true
   recipe::cargo kadabra abra
}
