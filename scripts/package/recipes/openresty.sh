#!/usr/bin/env bash
set -euo pipefail

package::install() {
    dot pkg add brew
    brew install openresty/brew/openresty
}
