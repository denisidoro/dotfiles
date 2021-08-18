#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/str.sh"

coll::new() {
   for x in "$@"; do
      echo "$x"
   done
}

coll::first() {
   head -n1
}

coll::rest() {
   tail -n +2
}

coll::map() {
   local -r fn="$1"

   # shellcheck disable=SC2013
   for x in $(cat); do
      "$fn" "$x"
   done
}

coll::filter() {
   local -r pred="$1"

   # shellcheck disable=SC2013
   for x in $(cat); do
      if "$pred" "$x"; then
         echo "$x"
      fi
   done
}

coll::remove() {
   local -r pred="$1"

   # shellcheck disable=SC2013
   for x in $(cat); do
      "$pred" "$x" || echo "$x"
   done
}

coll::without_empty_line() {
   local -r input="$(cat)"
   local -r words="$(echo "$input" | wc -w | xargs)"
   if [[ $words -gt 0 ]]; then
      echo "$input"
   fi
}

coll::add() {
   cat | coll::without_empty_line
   for x in "$@"; do
      echo "$x"
   done
}

coll::reverse() {
   str::reverse_lines "$@"
}

coll::set() {
   sort -u
}

coll::get() {
   local n="$1"
   n=$((n+1))
   sed "${n}q;d"
}

# TODO: implement tailrec
coll::reduce() {
   local -r fn="$1"
   local state="$2"

   local -r coll="$(cat)"
   local -r x="$(echo "$coll" | coll::first)"

   if [ -z "$x" ]; then
      echo "$state"
   else
      local -r new_state="$("$fn" "$state" "$x")"
      echo "$coll" | coll::rest | coll::reduce "$fn" "$new_state"
   fi
}

coll::is_empty() {
   local var=${1}
   [[ -z ${var} ]]
}

coll::contains_element() {
   elements="${*:2}"
   element="${1}"

   for e in "${elements[@]}"; do
      if [[ "$e" == "${element}" ]]; then
         return 1
      fi
   done
   return 0
}
