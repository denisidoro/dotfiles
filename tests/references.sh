#!/usr/bin/env bash

_pairs() {
   find . \( -name .git -prune \) -o \( -name modules -prune \) -o -name '*' -type f \
      -exec bash -c 'x="$(grep "dot " {})"; [ -n "$x" ] && echo "$x" | sed -e "s|^|{} \+ |"' \; \
      | grep -v 'completions' \
      | grep -v 'references' \
      | grep -v 'nav.sh' \
      | grep -v 'bin/dot' \
      | grep -v 'help.sh'
}

_files() {
   local -r pairs="$1"
   echo "$pairs" \
      | cut -d'+' -f1 \
      | sort -u
}

validate_reference() {
   local cmds=($(echo "$*" | tr ' ' '\n'))
   case "$*" in
      *cl*edn) return 0 ;;
      *sh*zsh) return 0 ;;
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
      if ! validate_reference "$c"; then
         log::error "$c isn't a valid command"
         return 1
      fi
   done
}

test::set_suite "bash - references"

pairs="$(_pairs)"
files="$(_files "$pairs")"

declare -A caches=()
for f in $files; do
   test::run "references to dot in $f are valid" validate_references "$pairs" "$f"
done
