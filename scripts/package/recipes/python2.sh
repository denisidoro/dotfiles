#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe python2 \
    || dot pkg add python@2 \
    || dot pkg add python2.7 \
    || dot pkg add python \
    || dot pkg add python3

   if ! has python2; then
      local -r py="$(which python)"
      sudo ln -s "$py" "${py}2"
   fi
}
