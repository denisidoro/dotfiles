#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add pipx
   pipx install pipenv
}
