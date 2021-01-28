#!/usr/bin/env bash
set -euo pipefail

package::install() {
   has brew && brew install camdencheek/brew/fre && return 0 || true
   recipe::cargo fre && return 0 || true

   GITHUB_USERNAME="denisidoro" REPO="fre" dot rust binary download
}