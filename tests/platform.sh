#!/usr/bin/env bash

existing() {
   platform::existing_command oasida fngo ni awk aoisdn oafm \
      | test::equals awk
}

test::set_suite "bash - platform"
test::run "existing_command" existing
