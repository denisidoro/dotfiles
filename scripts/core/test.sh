#!/usr/bin/env bash

export FORCE_GNU=true

source "${DOTFILES}/scripts/core/main.sh"
source "${DOTFILES}/scripts/core/coll.sh"

PASSED=0
FAILED=0
SKIPPED=0
RAN=false
SUITE=""

test::set_suite() {
   SUITE="$*"
}

test::success() {
   PASSED=$((PASSED+1))
   log::success "Test passed!"
}

test::filter_check() {
   if [ -n "${TEST_FILTER:-}" ]; then
      echo "${SUITE:-}" | grep -Eq "$TEST_FILTER" || return 1
   fi
   return 0
}

test::fail() {
   FAILED=$((FAILED+1))
   log::error "Test failed..."
   return
}

test::skip() {
   test::filter_check || return 0
   echo
   log::info "${SUITE:-unknown} | ${1:-unknown}"
   SKIPPED=$((SKIPPED+1))
   log::warn "Test skipped..."
   return
}

_with_sleep() {
   sleep "$1"
   shift
   "$@"
}

test::run() {
   test::filter_check || return 0
   echo
   log::info "${SUITE:-unknown} | ${1:-unknown}"
   shift
   RAN=true
   if "$@"; then
      test::success
   else
      test::fail
   fi
}

test::run_with_retry() {
   local -r name="$1"
   local -r fn="$2"
   shift 2

   new_test_fn() {
      "$fn" "$@" || _with_sleep 2 "$fn" "$@"
   }

   test::run "$name" new_test_fn "$@"
}

test::lazy_run() {
   test::filter_check || return 0
   "$@"
}

test::equals() {
   local -r actual="$(cat)"
   local -r expected="${1:-}"

   if [[ "$actual" != "$expected" ]]; then
      log::error "Expected...\n\n${expected}\n\n...but got:\n\n${actual}'"
      return 2
   fi
}

test::includes() {
   local -r actual="$(cat)"
   local -r should_include="${1:-}"

   if ! echo "$actual" | grep -Fq "$should_include"; then
      log::error "Expected the following string to include...\n\n${should_include}\n\n...but it doesn't:\n\n${actual}"
      return 3
   fi
}

test::finish() {
   echo
   if [ $SKIPPED -gt 0 ]; then
      log::warn "${SKIPPED} tests skipped!"
   fi
   if [ $FAILED -gt 0 ]; then
      log::error "${PASSED} tests passed but ${FAILED} failed... :("
      exit "${FAILED}"
   else
      log::success "All ${PASSED} tests passed! :)"
      exit 0
   fi
}

test::find_files() {
   local -r folder="${1:-"${DOTFILES}/tests/"}"
   find "$folder" -iname "*.sh"
}

test::start() {
   for test in $(test::find_files "$@"); do
      seconds=$SECONDS
      RAN=false
      log::debug "Start running tests in ${test}..."
      # shellcheck disable=SC1090
      source "$test"
      if ! $RAN; then
         continue
      fi
      delta=$((SECONDS - seconds))
      echoerr
      filename="$(basename "$test")"
      log::debug "Running ${filename} took ${delta} seconds"
   done

   test::finish
}
