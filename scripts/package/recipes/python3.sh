#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --ignore-recipe python3 \
    || dot pkg add python@3.8 \
    || dot pkg add python \
    || dot pkg add --ignore-recipe python2

   if ! has python3; then
      local -r py="$(which python)"
      sudo ln -s "$py" "${py}3"
   fi
}
