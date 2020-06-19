#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add python3
   dot pkg add git

   cd "$TMP_DIR"
   git clone https://github.com/bemeurer/beautysh
   cd beautysh

   has python3 && bin="python3" || bin="python"
   $bin setup.py install
}
