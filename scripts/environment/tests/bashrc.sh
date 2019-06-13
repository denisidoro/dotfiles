#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/environment/aux/test.sh"

test::fact "sourcing bashrc doesn't throw an exception"

cd "$DOTFILES"
bashrc_path="$(cat "symlinks/conf.yaml" | grep bashrc | awk '{print $2}')"

source "$bashrc_path" \
   && test::success || test::fail
