#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

TARGET="/data/data/com.termux/files/usr/bin/sudo"

if fs::is_file "$TARGET"; then
   recipe::abort_installed termux-sudo
fi

recipe::shallow_gitlab_clone st42 termux-sudo

cd "$(recipe::folder termux-sudo)"
cat sudo > "$TARGET"
chmod 700 "$TARGET"
