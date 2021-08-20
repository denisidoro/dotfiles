#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/log.sh"

_validate() {
   shellcheck -x \
      -e SC2154 \
      -e SC2119 \
      -e SC2002 \
      -e SC2096 \
      "$@"
}

_run() {
   local -r all_files="$(dot self shellcheck ls --all)"
   local -r files="$(dot self shellcheck ls)"
   for p in $all_files; do
      local test_fn=test::skip
      if echo "$files" | grep -q "$p"; then
         test_fn=test::run
      fi
      $test_fn "$p is correct" _validate "$p"
   done
}

test::set_suite "bash - shellcheck"
test::lazy_run _run