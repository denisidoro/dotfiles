#!/usr/bin/env bash
set -euo pipefail

user="kfix"
repo="ddcctl"

package::install() {
   platform::is_osx || return 1
   local -r folder="$(recipe::shallow_github_clone "$user" "$repo")"
   cd "$folder"
   recipe::install
}