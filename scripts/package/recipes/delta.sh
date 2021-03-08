#!/usr/bin/env bash
set -euo pipefail

package::install() {
   recipe::cargo git-delta
}
