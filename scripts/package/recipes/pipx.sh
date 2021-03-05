#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if has brew; then
     brew install pipx
    pipx ensurepath
    return 0
   fi

    dot pkg add python3
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
    dot pkg add python3-venv
}
