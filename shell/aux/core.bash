#!/usr/bin/env bash

echoerr() {
   echo "$@" 1>&2;
}

has() {
   type "$1" &>/dev/null
}

nonzero_return() {
   RETVAL=$?
   [ $RETVAL -ne 0 ] && echo "$RETVAL"
}