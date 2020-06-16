#!/usr/bin/env bash
set -euo pipefail

package::install() {
   bash <(curl -sL https://raw.githubusercontent.com/denisidoro/fre/master/scripts/install)
}