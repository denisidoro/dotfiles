#!/usr/bin/env bash
# vim: filetype=sh

_jsons() {
   cd "$DOTFILES"
   find . -iname "*.json" \
      | grep -Ev 'node_modules|cache|modules/|lock.json' \
      | sed 's|\./||g'
}

_valid_json() {
   cat "$1" \
      | jq . &>/dev/null
}

test::set_suite "jq - json"

for f in $(_jsons); do
   test::run "$f is syntactically valid" _valid_json "$f"
done
