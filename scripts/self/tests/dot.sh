#!/usr/bin/env bash
# vim: filetype=sh

health() {
   res="$(dot self health)"
   echo "$res" | grep "====" \
   }

test::set_suite "dict"
test::run "dot <ctx> <cmd> works" health
