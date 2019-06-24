#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/self/aux/test.sh"

test::fact "all JSONs are syntactically valid"

cd "$DOTFILES"

find . -iname "*.json" \
   | grep -Ev 'node_modules|cache|modules/|lock.json' \
   | xargs -I% dot code parser json % \
   && test::success || test::fail
