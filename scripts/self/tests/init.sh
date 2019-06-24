#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/self/aux/test.sh"

_output() {
   echo no | dot self install
}

test::fact "The installation scripts starts"

echo "$(_output)" \
   | grep risk \
   && test::success || test::fail
