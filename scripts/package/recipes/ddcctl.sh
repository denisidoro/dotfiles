#!/usr/bin/env bash
set -euo pipefail

user="kfix"
repo="ddcctl"

package::install() {
   platform::is_osx || return 1
   recipe::shallow_github_clone "$user" "$repo"
   cd "$(recipe::folder "$repo")"
   make intel
   sudo cp ./ddcctl /usr/local/bin/ddcctl
}