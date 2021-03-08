#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   has tldr
}

package::install() {
   recipe::cargo tealdeer
}
