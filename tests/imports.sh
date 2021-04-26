#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/log.sh"

_paths() {
   find . \( -name .git -prune \) -o \( -name modules -prune \) -o \( -name rust -prune \) -o \( -name target -prune \)  -o -name '*' -type f \
      -exec bash -c "grep -o '[^ =:]*DOTFILES[^ ]*' {}" \; \
      | grep -o '[^ =:]*DOTFILES[^ ]*' \
      | grep -Ev '=|local' \
      | grep -E 'scripts|shell' \
      | tr -d "\"(){}'\-" \
      | grep -v '/\$' \
      | sort -u
}

validate_path() {
   local p="$(echo "$1" | sed 's|\$DOTFILES|'"${DOTFILES}|")"
   [ -f "$p" ] || [ -d "$p" ]
}

_run() {
   local -r ifs="$IFS"
   for p in $(_paths); do
      test::run "$p is a valid path" validate_path "$p"
   done
}

test::set_suite "bash - imports"
test::lazy_run _run
