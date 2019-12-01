#!/usr/bin/env bash

SCRIPT_HOME="${DOTFILES}/scripts/package"

source "${DOTFILES}/scripts/core/coll.sh"
source "${DOTFILES}/scripts/core/dict.sh"
source "${DOTFILES}/scripts/core/documentation.sh"
source "${DOTFILES}/scripts/package/aux/recipes.sh"
for f in $(find "${DOTFILES}/scripts/package/aux/pkg_managers" -iname '*.sh'); do
   source "$f"
done
source "${DOTFILES}/scripts/package/aux/install.sh"
source "${DOTFILES}/scripts/package/aux/opts.sh"
source "${DOTFILES}/scripts/package/aux/package.sh"
source "${DOTFILES}/scripts/package/aux/pkg_manager.sh"

handler::help() {
   extract_help "$0"
}

handler::script() {
   "${SCRIPT_HOME}/scripts/${SCRIPT_ARGS[@]}"
}

handler::home() {
   echo "${SCRIPT_HOME}"
}

handler::pkg_manager_operation() {
   local -r operation="$1"

   local -r packages="$(dict::get "$OPTIONS" values)"
   local -r pkg_managers="$(dict::get "$OPTIONS" pkg_managers)"

   for pkg_manager in $pkg_managers; do
      if "${pkg_manager}::${operation}" "$packages"; then
         return 0
      fi
   done

   return 1
}

main() {
   local -r entry_point="$(dict::get "$OPTIONS" entry_point)"
   case $entry_point in
      install)
         handler::install
         ;;
      version)
         handler::version false
         ;;
      full-version)
         handler::version true
         ;;
      home)
         handler::home
         ;;
      script)
         handler::script
         ;;
      help)
         handler::help
         ;;
      remove)
         handler::pkg_manager_operation "$entry_point"
         ;;
   esac
}
