#!/usr/bin/env bash
# vim: filetype=sh

health() {
   dot self health --help | grep -q Usage
}

test::set_suite "dict"
test::run "dot <ctx> <cmd> works" health
