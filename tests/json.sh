#!/usr/bin/env bash

_jsons() {
   cd "$DOTFILES"
   find . -iname "*.json" \
      | grep -Ev 'node_modules|cache|modules/|rust/|target|lock.json' \
      | sed 's|\./||g'
}

_valid_json() {
   local -r file="$1"
   cat "$file" | grep -v '//' | jq . >/dev/null
}

_run() {
   cd "$DOTFILES"
   for f in $(_jsons); do
      test::run "$f is syntactically valid" _valid_json "$f"
   done
}

test::set_suite "js - json"
test::lazy_run _run
