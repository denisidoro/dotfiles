#!/usr/bin/env bash
set -euo pipefail

package::install() {
   yarn add global terminalizer \
      || npm install -g terminalizer
}
