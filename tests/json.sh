#!/usr/bin/env bash

_jsons() {
   cd "$DOTFILES" || exit
   find . -iname "*.json" \
      | grep -Ev 'node_modules|cache|modules/|rust/|target|lock.json' \
      | sed 's|\./||g'
}

_valid_json() {
   local -r file="$1"
   grep -v '//' "$file" | jq . >/dev/null
}

_run() {
   cd "$DOTFILES" || exit
   for f in $(_jsons); do
      test::run "$f is syntactically valid" _valid_json "$f"
   done
}

test::set_suite "js - json"
test::lazy_run _run
