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

if platform::command_exists node; then
  test_fn="test::run"
else
  test_fn="test::skip"
fi

test::set_suite "tasker js"
$test_fn "randomLine" random_line