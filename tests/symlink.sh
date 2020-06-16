#!/usr/bin/env bash
 
_validate() {
   local -r filename="$1"
   local success=true

   local -r files="$(cat "$filename" \
      | sed '/^$/d' \
      | cut -d',' -f1)"

   for f in $files; do
      if [[ -f "$f" || -d "$f" ]]; then
         :
      else
         echoerr "☓ $f"
         success=false
      fi
   done

   $success && return 0 || return 1
}

cd "$DOTFILES"

test::set_suite "bash - symlink"

for f in $(ls "./links/"); do
   test::run "$f - symlinks are valid" _validate "./links/$f"
done