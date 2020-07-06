#!/usr/bin/env bash

custom::safe_call() {
   local -r fn="$1"

   if has "$fn"; then
      "$fn"
   else
      return 42
   fi
}

custom::install() {
   local -r package="$1"

   local -r depend_fn="$(package::fn "$package" depends_on)"

   if has "$depend_fn"; then
      echoerr dep_fn "$depend_fn"
      local dependencies="$($depend_fn)"
      for dependency in $dependencies; do
         install_if_not_installed "$dependency" || true
      done
   fi

   local -r fn="$(package::fn "$package" install)"
   custom::safe_call "$fn"
}

custom::remove() {
   local -r package="$1"

   local -r fn="$(package::fn "$package" remove)"
   custom::safe_call "$fn"
}

custom::info() {
   local -r package="$1"

   local -r fn="$(package::fn "$package" info)"
   custom::safe_call "$fn"
}
