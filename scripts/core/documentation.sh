#!/usr/bin/env bash

docs::help() {
   local -r file="$1"
   grep "^##?" "$file" | cut -c 5-
}

docs::eval() {
   local -r file="$0"
   local -r help="$(docs::help "$file")"

   if [[ ${DOT_DOCOPT:-python} == "python" ]]; then
      local -r docopt="${DOTFILES}/scripts/core/docopts"
   else
      local -r docopt="$DOT_DOCOPT"
   fi

   eval "$("$docopt" -h "${help}" : "${@:1}")"
}

docs::eval_help() {
   local -r file="$0"

   case "${!#:-}" in
      -h|--help|--version) docs::help "$file"; exit 0 ;;
   esac
}

docs::invalid() {
   local -r file="$0"

   docs::help "$file"
   exit 1
}