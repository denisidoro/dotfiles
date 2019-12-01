#!/usr/bin/env bash
# vim: filetype=sh

_bins() {
   cd "${DOTFILES}/scripts"
   find . -type f -executable -print \
      | grep -v node_modules \
      | grep -v './core'
}

assert_help() {
   local -r bin="$1"
   local -r words="$(echo "$bin" | tr -d '.' | tr '/' ' ' | xargs)"
   local -r ctx="$(echo "$words" | awk '{print $1}')"
   local -r cmd="$(echo "$words" | awk '{print $2}')"

   dot "$ctx" "$cmd" --help | grep -q Usage
}

test::set_suite "help"

for bin in $(_bins); do
   test::run "${bin} has a --help command" assert_help "$bin"
done