#!/usr/bin/env bash

echoerr() {
   echo "$@" 1>&2
}

url::open() {
   local -r cmd="$(platform::existing_command "${BROWSER:-}" xdg-open open google-chrome firefox)"
   "$cmd" "$@" & disown
}

tap() {
   local -r input="$(cat)"
   echoerr "$input"
   echo "$input"
}