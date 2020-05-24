#!/usr/bin/env bash
set -euo pipefail

source "$DOTFILES/scripts/core/main.sh"
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
   exit ${1:-0}
}

trap_exit() { # move to core?
   safe_exit
   die "Exit trapped. In function: '${FUNCNAME[*]}'"
}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # move to core?
IFS=$' \n\t'

trap trap_exit EXIT INT TERM
docs::eval "$@"
main
safe_exit
