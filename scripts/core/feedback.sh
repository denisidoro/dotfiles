#!/usr/bin/env bash

source "$DOTFILES/scripts/core/debug.sh"

feedback::confirmation() {
   local readonly msg="$1"
   local readonly default_yes="${2:-true}"
   local readonly options

   if $default_yes; then
      options="(Y|n)"
   else
      options="(y|N)"
   fi

   echo
   log::warning "$msg"
   read -p "$options " -n 1 -r </dev/tty
   local reply="$REPLY"
   echo

   if [[ -z "$reply" ]]; then
      if $default_yes; then
         return 0
      else
         return 1
      fi
   fi

   echo
   if echo "$reply" | grep -E '^[Yy]$' >/dev/null; then
      return 0
   else
      return 1
   fi
}

feedback::text() {

   local readonly question="$1"
   printf "$1 " >&2
   read answer
   echo "$answer"

}