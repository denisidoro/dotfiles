#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add luarocks
   luarocks install luacheck
}
