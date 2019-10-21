#!/usr/bin/env bash
# vim: filetype=sh

_validate() {
   local -r filename="$1"
   log::warning "Validating $filename..."
   cat "$filename" \
      | grep '\- link:' -A10000 \
      | tail -n +2 \
      | cut -d':' -f2 \
      | xargs -I% bash -c 'printf "% "; (test -f % || test -d %) && echo ✓ || echo ☓'
   echo
}

symlinks() {
   cd "$DOTFILES"
   result=""
   for f in $(ls "./symlinks/"); do
      result="$result$(_validate "./symlinks/$f")\n\n"
   done

   echo -e "$result" | head -n -2
   echo

   echo $result \
      | grep -qv "☓"
}

test::set_suite "symlink"
test::run "all symlinks are valid"