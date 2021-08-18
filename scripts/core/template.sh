#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES}/scripts/core/main.sh"
import "" # todo

##? Brief script explanation
##?
##? Usage
##?    script args

main() {
   echo -n
}

safe_exit() { # move to core?
   echo -n
   trap - INT TERM EXIT
   exit "${1:-0}"
}

trap_exit() { # move to core?
   safe_exit
   die "Exit trapped. In function: '${FUNCNAME[*]}'"
}

IFS=$' \n\t'

trap trap_exit EXIT INT TERM
doc::parse "$@"
main
safe_exit "$@"
