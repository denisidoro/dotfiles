#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add --prevent-recipe pnpm && return 0 || true

   yarn global add pnpm \
      || npm install -g pnpm \
   }
