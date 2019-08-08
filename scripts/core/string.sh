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

str::urlencode() {
   local data
   data="$(curl -s -o /dev/null -w %{url_effective} --get --data-urlencode "$1" "")"
   if [[ $? != 3 ]]; then
      echo "Unexpected error" 1>&2
      return 2
   fi
   echo "${data##/?}"
   return 0
}

str:::without_line_break() {
   echo -n "$(cat)"
}