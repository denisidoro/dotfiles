#!/usr/bin/env bash

extract_help() {
   local file="$1"
   grep "^##?" "$file" | cut -c 5-
}

_get_awk_version() {
   awk -Wversion 2> /dev/null \
      || awk --version
}

docs::eval() {
   local readonly file="$0"
   help="$(extract_help "$file")"

   if [[ ${DOTFILES_DOCOPTS:-python} == "bash" ]]; then
      if _get_awk_version | head -n1 | grep -q mawk 2> /dev/null; then
         echo "Parsing docopts with mawk won't work. Please install gawk or python"
         exit 666
      fi
      docopts="$DOTFILES/modules/docoptsh/docoptsh"
   else
      docopts="$DOTFILES/scripts/core/docopts"
   fi

   if [[ ${1:-} == "--version" ]]; then
      local readonly version_code=$(grep "^#??" "$file" | cut -c 5- || echo "unversioned")
      git_info=$(cd "$(dirname "$file")" && git log -n 1 --pretty=format:'%h%n%ad%n%an%n%s' --date=format:'%Y-%m-%d %Hh%M' -- "$(basename "$file")")
      version="$(echo -e "${version_code}\n${git_info}")"
      eval "$($docopts -h "${help}" -V "${version}" : "${@:1}")"
   else
      eval "$($docopts -h "${help}" : "${@:1}")"
   fi
}
