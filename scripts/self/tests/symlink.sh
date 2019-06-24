#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/self/aux/test.sh"

_validate() {
   local readonly filename="$1"
   log::warning "Validating $filename..."
   cat "$filename" \
      | grep '\- link:' -A10000 \
      | tail -n +2 \
      | cut -d':' -f2 \
      | xargs -I% bash -c 'printf "% "; (test -f % || test -d %) && echo ✓ || echo ☓'
   echo
}

test::fact "all symlinks are valid"

cd "$DOTFILES"
result=""
for f in $(ls "./symlinks/"); do
   result="$result$(_validate "./symlinks/$f")\n\n"
done

echo -e "$result" | head -n -2
echo

echo $result \
   | grep -qv "☓" \
   && test::success || test::fail
