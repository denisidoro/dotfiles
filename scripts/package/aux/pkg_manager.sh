#!/usr/bin/env bash

pkg_manager::all() {
   coll::new brew
   if ! platform::is_osx; then
      coll::new apt yum pacman pkg apk opkg
   fi
   coll::new custom
   coll::new npm pip
}

custom_or_exists() {
   local -r arg="${1:-}"
   if [[ "$arg" = "custom" ]]; then
      return 0
   fi
   platform::command_exists "$arg"
}

pkg_manager::relevant() {
   pkg_manager::all \
      | coll::filter custom_or_exists
}
