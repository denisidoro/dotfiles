#!/usr/bin/env bash
set -euo pipefail

_gen_file() {
   local -r shell="$1"
   echo "${HOME}/.${shell}rc"
}

package::is_installed() {
   local -r f="$(_gen_file bash)"
   
   if ! [ -f "$f" ]; then
      return 1
   fi

   cat "$f" | grep -q 'DOTFILES'
}

_install() {
   local -r shell="$1"
   local -r f="$(_gen_file "$shell")"
   
   if ! [ -f "$f" ]; then
      touch "$f"
   fi

   echo "source '${DOTFILES}/shell/${shell}/${shell}rc'" >> "$f"
}

package::install() {
   _install bash
   _install zsh
}
