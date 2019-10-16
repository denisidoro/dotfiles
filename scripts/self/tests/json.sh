#!/usr/bin/env bash
# vim: filetype=sh

valid_json() { 
  cd "$DOTFILES"

  find . -iname "*.json" \
     | grep -Ev 'node_modules|cache|modules/|lock.json' \
     | xargs -I% dot code parser json %
}

test::set_suite "json"
test::run "all JSONs are syntactically valid" valid_json
