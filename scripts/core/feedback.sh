#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/log.sh"

feedback::confirmation() {
   local -r msg="$1"
   local -r default_yes="${2:-true}"
   local options

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

feedback::enter() {
   read -p "Press enter to continue"
}

feedback::text() {
   local -r question="$1"
   printf "$1 " >&2
   read answer
   echo "$answer"
}

feedback::select_option_fallback() {
   local -r options="$1"
   local -r question="$2"

   local -r digits="$(printf "$options" | wc -l | wc -m | xargs -I% echo "% - 1" | bc 2> /dev/null || echo 2)"
   echo "$options" | awk "{printf(\"%${digits}d %s\n\", NR, \$0)}" > /dev/tty
   echo

   local selection="$(feedback::text "$question" <> /dev/tty)"

   local index=1
   for option in $options; do
      if [[ $index = "$selection" ]]; then
         selection="$option"
         break
      fi
      index=$((index + 1))
   done

   echo "$selection"
}

feedback::select_option() {
   local -r options="$(cat)"
   local -r question="${1:-Select a number}"

   if has fzf; then
      local height="$(echo "$options" | wc -l)"
      height="$((height + 2))"
      echo "$options" \
         | fzf-tmux \
         --height "$height" \
         --cycle \
         --inline-info \
         --header "$question" \
         --reverse
   else
      feedback::select_option_fallback "$options" "$question" \
         | tail -n1
   fi
}