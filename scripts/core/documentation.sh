#!/usr/bin/env bash

extract_help() {
   local readonly file="$1"
   grep "^##?" "$file" | cut -c 5-
}

_compose_version() {
   local readonly file="$1"
   local readonly version_code=$(grep "^#??" "$file" | cut -c 5- || echo "unversioned")
   local readonly git_info=$(cd "$(dirname "$file")" && git log -n 1 --pretty=format:'%h%n%ad%n%an%n%s' --date=format:'%Y-%m-%d %Hh%M' -- "$(basename "$file")")
   echo -e "${version_code}\n${git_info}"
}

docs::eval() {
   local readonly file="$0"
   local readonly help="$(extract_help "$file")"

   case ${DOT_DOCOPTS:-python} in
      bash)
         docopts="${DOTFILES}/modules/docoptsh/docoptsh"
         ;;
      python)
         docopts="${DOTFILES}/scripts/core/docopts"
         ;;
      go)
         docopts="docopts"
         ;;
   esac

   if [[ ${1:-} == "--version" ]]; then
      local readonly version="$(_compose_version "$file")"
      eval "$($docopts -h "${help}" -V "${version}" : "${@:1}")"
   else
      eval "$($docopts -h "${help}" : "${@:1}")"
   fi
}

docs::eval_help() {
   local readonly file="$0"

   case "${!#:-}" in
      -h|--help) extract_help "$file"; exit 0 ;;
      --version) _compose_version "$file"; exit 0 ;;
   esac
}
