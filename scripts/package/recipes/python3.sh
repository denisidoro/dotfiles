#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe python3 \
    || dot pkg add python

   if ! platform::command_exists python3; then
      local -r py="$(which python)"
      sudo ln -s "$py" "${py}3"
   fi
}
