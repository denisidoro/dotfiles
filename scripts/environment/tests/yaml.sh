#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/environment/aux/test.sh"

test::fact "all YAMLs are syntactically valid"

_find_yamls() {
   find . -iname "*.yaml"
   find . -iname "*.yml"
}

cd "$DOTFILES"

_find_yamls \
   | grep -Ev 'node_modules|cache|modules/|lock.json' \
   | xargs -I% "$DOT_PATH" -d code parser yaml % \
   && test::success || test::fail
