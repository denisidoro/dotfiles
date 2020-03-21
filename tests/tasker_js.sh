#!/usr/bin/env bash
# vim: filetype=sh

random_line() {
   local -r lines="foo\nbar"

   local -r lib="$(cat "${DOTFILES}/tasker/js/core.js")"
   local -r out="$(node --eval "${lib}; console.log(randomLine('${lines}'))")"

   case "$out" in
      foo|bar) ;;
      *) return 1 ;;
   esac
}

test::set_suite "node - tasker js"
$test_fn "randomLine" random_line