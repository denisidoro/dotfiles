#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/environment/aux/test.sh"

_output() {
   echo no | "$DOT_BIN" "environment" "install"
}

test::fact "The installation scripts starts"

echo "$(_output)" \
   | grep risk \
   && test::success || test::fail
