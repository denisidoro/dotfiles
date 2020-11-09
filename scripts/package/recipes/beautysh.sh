#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add pip3
   pip3 install beautysh
}
