#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

TARGET="/data/data/com.termux/files/usr/bin/sudo"

termux-sudo::is_installed() {
   fs::is_file "$TARGET"
}

termux-sudo::install() {
   recipe::shallow_gitlab_clone st42 termux-sudo

   cd "$(recipe::folder termux-sudo)"
   cat sudo > "$TARGET"
   chmod 700 "$TARGET"
}
