#!/usr/bin/env bash
set -euo pipefail

package::install() {
   platform::command_exists brew && brew install denisidoro/tools/docpars
}
