#!/usr/bin/env bash

_validate() {
   local -r filename="$1"
   local success=true

   echoerr "validate: $*"

   local -r files="$(sed '/^$/d' "$filename" | cut -d',' -f1)"

   for f in $files; do
      if echo "$f" | grep -q 'local/'; then
         :
      elif [[ -f "$f" || -d "$f" ]]; then
         :
      else
         echoerr "☓ $f"
         success=false
      fi
   done

   $success && return 0 || return 1
}

cd "$DOTFILES" || exit

test::set_suite "bash | symlink"

for f in ./links/[^gdrive]*; do
   test::run "$f - symlinks are valid" _validate "$f"
done