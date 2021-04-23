#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/log.sh"

_pairs() {
   find . \( -name .git -prune \) -o \( -name modules -prune \) -o \( -name rust -prune \) -o \( -name target -prune \)  -o -name '*' -type f \
      -exec bash -c 'x="$(grep "dot " {})"; [ -n "$x" ] && echo "$x" | sed -e "s|^|{} \+ |"' \; \
      | grep -v 'completions' \
      | grep -v 'references' \
      | grep -v 'nav.sh' \
      | grep -v 'bin/dot' \
      | grep -v 'help.sh'
}

validate_reference() {
   local cmds=($(echo "$*" | tr ' ' '\n'))
   case "$*" in
      *uber*|*work*) ;;
      *) "${cmds[@]}" --help &>/dev/null ;;
   esac
}

_run() {
   local -r ifs="$IFS"
   local -r pairs="$(_pairs)"
   echoerr "pairs: $pairs"
   local -r calls="$(echo "$pairs" | grep -Eo 'dot ([a-z][a-z0-9]+) ([a-z][a-z0-9-]+)' | sort -u)"
   IFS=$'\n'
   for c in $calls; do
      IFS="$ifs"
      test::run_with_retry "$c is a valid command" validate_reference "$c"
   done
}

test::set_suite "bash - references"
test::lazy_run _run
