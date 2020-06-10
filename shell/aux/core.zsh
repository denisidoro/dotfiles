#!/usr/bin/env bash

echoerr() {
   echo "$@" 1>&2;
}

has() {
   type "$1" &>/dev/null
}