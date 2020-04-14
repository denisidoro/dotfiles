#!/usr/bin/env bash
# vim: filetype=sh

include() {
   [[ -f "$1" ]] && source "$1"
}

indexof() {
   local -r index="$1"
   i=0;
   shift
   while [ "$i" -le "$#" ]; do
      if [ "${@:$i:1}" = "$index" ]; then
         echo $i
         return
      fi
      ((i++));
   done;
   echo -1;
}

nonzero_return() {
   RETVAL=$?
   [ $RETVAL -ne 0 ] && echo "$RETVAL"
}

dot_or_args() {
   local -r dash_index="$(indexof "--" "$@")"
   readonly fn="${@:1:$((dash_index-1))}"
   shift $dash_index
   if [[ $# < 1 ]]; then
      eval ${fn[@]} .
   else
      eval ${fn[@]} "$@"
   fi
}

echoerr() { 
   echo "$@" 1>&2; 
}