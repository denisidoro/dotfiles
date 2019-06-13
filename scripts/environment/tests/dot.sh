#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/environment/aux/test.sh"

res="$(dot environment health)"

test::fact "dot <ctx> <cmd> works"

echo "$res" | grep "====" \
   && test::success || test::fail
