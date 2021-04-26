#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   ! platform::is_osx \
      || has gcat
}

package::install() {
   dot pkg add brew

   brew install binutils diffutils findutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gzip wget m4 make nano file-formula gzip wget
}