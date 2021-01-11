#!/usr/bin/env bash
set -euo pipefail

package::install() {
   has cargo && cargo install fre && return 0 || true
   has brew && brew install camdencheek/brew/fre && return 0 || true
   dot pkg add fre --prevent-recipe && return 0 || true

   GITHUB_USERNAME="denisidoro" REPO="fre" dot rust binary download
}