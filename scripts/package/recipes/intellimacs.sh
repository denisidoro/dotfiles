#!/usr/bin/env bash
set -euo pipefail

TARGET="${HOME}/.intellimacs"
REPO="https://github.com/MarcoIeni/intellimacs"

package::is_installed() {
   [ -d "$TARGET" ]
}

package::install() {
   git clone "$REPO" "$TARGET" --depth 1
}
