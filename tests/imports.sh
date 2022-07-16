#!/usr/bin/env bash

_paths() {
   pwd
   # shellcheck disable=SC2156
   find . \( -name .git -prune \) -o \( -name modules -prune \) -o \( -name node_modules -prune \) -o \( -name rust -prune \) -o \( -name target -prune \)  -o -name '*' -type f \
      -exec bash -c "grep -o '[^ =:]*DOTFILES[^ ]*' {}" \; \
      | grep -o '[^ =:]*DOTFILES[^ ]*' \
      | grep -Ev '=|local' \
      | grep -E 'scripts|shell' \
      | tr -d "\"(){}'\-" \
      | grep -v '/\$' \
      | sort -u
}

validate_path() {
   local -r p="${1//\$DOTFILES/$DOTFILES}"
   [ -f "$p" ] || [ -d "$p" ]
}

_run() {
   for p in $(_paths); do
      test::run "$p is a valid path" validate_path "$p"
   done
}

test::set_suite "bash | imports"
test::lazy_run _run
