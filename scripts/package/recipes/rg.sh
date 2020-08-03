#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe ripgrep && exit 0 || true
   dot pkg add --prevent-recipe rg
}
