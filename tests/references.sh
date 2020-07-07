#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/log.sh"

_pairs() {
   find . \( -name .git -prune \) -o \( -name modules -prune \) -o \( -name rust -prune \) -o \( -name target -prune \)  -o -name '*' -type f \
      -exec bash -c 'x="$(grep "dot " {})"; [ -n "$x" ] && echo "$x" | sed -e "s|^|{} \+ |"' \; \
      | grep -v 'completions' \
      | grep -v 'references' \
      | grep -v 'nav.sh' \
      | grep -v 'bin/dot' \
      | grep -v 'help.sh' \
      | grep -v 'terminal/scripting'
}

_files() {
   local -r pairs="$1"
   echo "$pairs" \
      | cut -d'+' -f1 \
      | sort -u \
      | sed 's|\./||g'
}

validate_reference() {
   local cmds=($(echo "$*" | tr ' ' '\n'))
   case "$*" in
      *uber*|*work*) ;;
      *"rust call"*|*"rust run"*) ;;
      *) "${cmds[@]}" --help &>/dev/null ;;
   esac
}

validate_references() {
   local -r all_pairs="$1"
   local -r file="$2"
   local -r pairs="$(echo "$all_pairs" | grep "$file +")"
   local -r calls="$(echo "$pairs" | grep -Eo 'dot ([a-z][a-z0-9]+) ([a-z][a-z0-9-]+)' | sort -u)"
   IFS=$'\n'
   for c in $calls; do
      test::run_with_retry "$c is a valid command" validate_reference "$c"
   done
}

_run() {
   local -r all_pairs="$(_pairs)"
   local -r files="$(_files "$all_pairs")"
   declare -A caches=()
   for f in $files; do
      test::run "$f" validate_references "$all_pairs" "$f"
   done
}

test::set_suite "bash - references"
test::lazy_run _run
