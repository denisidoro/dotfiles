#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/platform.sh"

existing() {
   platform::existing_command oasida fngo ni awk aoisdn oafm \
      | test::equals awk
}

test::set_suite "bash | platform"
test::run "existing_command" existing
