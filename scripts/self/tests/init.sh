#!/usr/bin/env bash
# vim: filetype=sh

_output() {
   echo no | dot self install
}

init_works() {
   echo "$(_output)" \
      | grep -q risk
}

test::set_suite "init"
test::skip "The installation script starts" init_works
