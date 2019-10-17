#!/usr/bin/env bash
# vim: filetype=sh

print_health() {
   dot git checkout --help | grep -q Usage
}

test::set_suite "doc"
test::run "eval_help" print_health
