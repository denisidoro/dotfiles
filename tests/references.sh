#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/log.sh"

_files() {
   find . \
      \( -name .git -prune \) \
      -o \( -name modules -prune \) \
      -o \( -name rust -prune \) \
      -o \( -name target -prune \)  \
      -o \( -name repos -prune \)  \
      -o -name '*' \
      -type f \
      | grep -v 'completions' \
      | grep -v 'references' \
      | grep -v 'bin/dot' \
      | grep -v 'STORE' \
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
   declare -A checked
   for file in $(_files); do
      [ -f "$file" ] || continue
      local call="$(grep -Eo 'dot [a-zA-z0-9_\-]+ [a-zA-z0-9_\-]+' "$file")"
      [ -n "$call" ] || continue
      echo "call: $call, checked: ${checked[$call]:-}"
      if [ "${checked[$call]:-}" ]; then
         continue
      fi
      while IFS= read -r line; do
         local ctx="$(echo "$line" | cut -d' ' -f2)"
         local cmd="$(echo "$line" | cut -d' ' -f3)"
         [ -n "$cmd" ] || continue
         echo "${ctx};${cmd};"
         checked[$call]=1
      done <<< "$call"
   done
}

# test::set_suite "bash - references"
# test::lazy_run _run

_run