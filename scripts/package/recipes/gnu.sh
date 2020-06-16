#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   ! platform::is_osx \
      || platform::command_exists ggrep
}

package::install() {
   brew tap homebrew/dupes
   brew install binutils diffutils findutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gzip wget
   brew install wdiff --with-gettext
   brew install m4 make nano file-formula
}