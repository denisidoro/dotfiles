#!/usr/bin/env bash

echoerr() {
   echo "$@" 1>&2;
}

has() {
   type "$1" &>/dev/null
}

tap() {
   local -r input="$(cat)"
   echoerr "$input"
   echo "$input"
}

nonzero_return() {
   RETVAL=$?
   [ $RETVAL -ne 0 ] && echo "$RETVAL"
}