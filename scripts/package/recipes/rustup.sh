#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add curl
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}