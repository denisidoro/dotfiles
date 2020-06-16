#!/usr/bin/env bash

docs::extract_help() {
   local -r file="$1"
   grep "^##?" "$file" | cut -c 5-
}

docs::help() {
   docs::extract_help "$@"
   exit 0
}

_compose_version() {
   local -r file="$1"
   local -r git_info=$(cd "$(dirname "$file")" && git log -n 1 --pretty=format:'%h%n%ad%n%an%n%s' --date=format:'%Y-%m-%d %Hh%M' -- "$(basename "$file")")
   echo -e "$git_info"
}

docs::eval() {
   local -r file="$0"
   local -r help="$(docs::extract_help "$file")"

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
      -h|--help) docs::extract_help "$file"; exit 0 ;;
      --version) _compose_version "$file"; exit 0 ;;
   esac
}

docs::eval_help_first_arg() {
   local -r file="$0"

   case "${1:-}" in
      -h|--help) docs::extract_help "$file"; exit 0 ;;
      --version) _compose_version "$file"; exit 0 ;;
   esac
}
