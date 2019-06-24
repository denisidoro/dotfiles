#!/usr/bin/env bash
# vim: filetype=sh

DEP_LIST_FILE="${DOTFILES}/scripts/package/aux/dependencies.ini"

batch::dependencies() {
   local readonly name="$1"

   for key in "$@"; do
      cat "$DEP_LIST_FILE" \
         | grep -A999 "\[${name}\].*" \
         | sed '/^ *$/q' \
         | tail -n +2
   done
}

str::join() {
   tr '\n' ' '
}
