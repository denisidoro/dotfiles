#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add pip3 || true
   pip3 install cqlsh || true
   pip3 install cqlsh
}
