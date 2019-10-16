#!/usr/bin/env bash
# vim: filetype=sh

test::fact

_find_yamls() {
   find . -iname "*.yaml"
   find . -iname "*.yml"
}

validate_yaml() {
   cd "$DOTFILES"

   _find_yamls \
      | grep -Ev 'node_modules|cache|modules/|lock.json' \
      | xargs -I% dot code parser yaml %
}

test::suite "yaml"
test::run "all YAMLs are syntactically valid" validate_yaml