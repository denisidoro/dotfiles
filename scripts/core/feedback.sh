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

   log::warning "$msg"
   read -p "$options " -n 1 -r </dev/tty
   local reply="$REPLY"

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

feedback::select_option() {
   if platform::command_exists fzf; then
      fzf "$@"
   else 
      local readonly options="$(cat)"
      local readonly digits="$(printf "$options" | wc -l | wc -m | xargs -I% echo "% - 1" | bc || echo 2)"
      echo "$options" | awk "{printf(\"%${digits}d %s\n\", NR, \$0)}"
      echo

      local selection="$(feedback::text "Select a number:" <> /dev/tty)"

      local index=1
      for option in $options; do
         if [[ $index = "$selection" ]]; then
            selection="$option"
            break
         fi
         index=$((index + 1))
      done

      echo "$selection"
   fi
}