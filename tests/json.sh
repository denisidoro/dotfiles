#!/usr/bin/env bash

_jsons() {
   cd "$DOTFILES"
   find . -iname "*.json" \
      | grep -Ev 'node_modules|cache|modules/|rust/|target|lock.json' \
      | sed 's|\./||g'
}

_maybe_remove_comments() {
   if has jsmin; then
      jsmin
   else
      cat
   fi
}

_valid_json() {
   cat "$1" \
      | _maybe_remove_comments \
      | jq . &>/dev/null
}

_run() {
   cd "$DOTFILES"
   for f in $(_jsons); do
      test::run "$f is syntactically valid" _valid_json "$f"
   done
}

test::set_suite "js - json"
test::lazy_run _run
