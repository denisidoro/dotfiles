#!/usr/bin/env bash

custom::safe_call() {
   local -r fn="$1"

   if platform::command_exists "$fn"; then
      "$fn"
   else
      return 42
   fi
}

custom::install() {
   local -r package="$1"

   local -r depend_fn="$(package::fn "$package" install)"

   if platform::command_exists "$depend_fn"; then
      local dependencies="$($depend_fn)"
      for package in $dependencies; do
         install_if_not_installed "$package"
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
