#!/usr/bin/env bash
# vim: filetype=sh

str::capitalize() {
   echo "$(tr '[:lower:]' '[:upper:]' <<<${1:0:1})${1:1}"
}

str::contains() {
   if [[ "${1}" == *"${2}"* ]]; then
      return 0
   else
      return 1
   fi
}

str::uppercase() {
   cat | tr '[:lower:]' '[:upper:]'
}

str::trim_newlines() {
   tr -d "\n"
}

str::last_word() {
   grep -oE '[^ ]+$'
}

str::remove_last_char() {
   echo "${1:0:${#1}-1}"
}
