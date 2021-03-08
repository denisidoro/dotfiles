#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add volta
   dot pkg proxy volta add reveal-md
}
