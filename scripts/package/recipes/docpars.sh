#!/usr/bin/env bash
set -euo pipefail

package::install() {
   package::command_exists brew && brew install denisidoro/tools/docpars
}
