#!/usr/bin/env bash
# vim: filetype=sh

ESCAPE_CHAR="\034"
ESCAPE_CHAR_2="\035"
ESCAPE_CHAR_3="\036"

str::length() {
   awk '{print length}'
}

str::sub() {
   local -r start="${1:-0}"
   local -r finish="${2:-99999}"

   cut -c "$((start + 1))-$((finish - 1))"
}

str::column() {
   local -r n="${1:-}"

   if [ -n "$n" ]; then
      awk "{print \$$n}"
   else
      cat
   fi
}

str::last_paragraph_line() {
   awk '(!NF) { exit } { print $0 }' \
      | tail -n1
}

str::first_word() {
   awk '{print $1}'
}

str::index_last_occurrence() {
   local -r char="$1"

   awk 'BEGIN{FS=""}{ for(i=1;i<=NF;i++){ if($i=="'"$char"'"){ p=i } }}END{  print p }'
}

str::reverse_lines() {
   if platform::command_exists tac; then
      tac
   elif platform::command_exists perl; then
      perl -e 'print reverse <>'
   else
      awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--] }'
   fi
}

str::not_empty() {
   local -r input="$(cat)"

   if [ -n $input ]; then
      echo "$input"
   else
      return 1
   fi
}

str::remove_empty_lines() {
   sed '/^$/d'
}

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