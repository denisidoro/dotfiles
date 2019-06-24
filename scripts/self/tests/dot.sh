#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/self/aux/test.sh"

res="$(dot self health)"

test::fact "dot <ctx> <cmd> works"

echo "$res" | grep "====" \
   && test::success || test::fail
