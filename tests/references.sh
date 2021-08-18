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
   case "$*" in
      *uber*|*work*) ;;
      *) dot "$@" --help &>/dev/null ;;
   esac
}

_run() {
   local call ctx cmd
   echoerr 1
   declare -A checked
   echoerr 2
   for file in $(_files); do
   echoerr 3
   echoerr $file
      [ -f "$file" ] || continue
   echoerr 4
      call="$(grep -Eo 'dot [a-zA-z0-9_\-]+ [a-zA-z0-9_\-]+' "$file")"
   echoerr 5
      [ -n "$call" ] || continue
      while IFS= read -r line; do
   echoerr 6
         case "$line" in 
            *add_to_dotlink*) continue ;;
            *add\ -m*) continue ;;
         esac
         if [ "${checked[$line]:-}" ]; then
            continue
         fi
         ctx="$(echo "$line" | cut -d' ' -f2)"
         cmd="$(echo "$line" | cut -d' ' -f3)"
         [ -n "$cmd" ] || continue
         test::run "the call dot ${ctx} ${cmd} in ${file} is valid" validate_reference "$ctx" "$cmd"
         checked[$line]=1
      done <<< "$call"
   done
}

test::set_suite "bash - references"
test::lazy_run _run