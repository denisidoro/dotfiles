#!/usr/bin/env bash

if platform::command_exists apt-get && ! platform::command_exists apt; then
   apt() {
      apt-get "$@"
   }

   export -f apt-get
fi

apt::install() {
   local -r ask="$(dict::get "$OPTIONS" ask)"
   sudo apt install $([ ! $ask ] && echo "--yes") "$@"
}

apt::remove() {
   sudo apt remove "$@"
}

apt::update() {
   sudo apt update "$@"
}

apt::upgrade() {
   apt::update "$@" || true
   sudo apt upgrade "$@"
}

apt::clean() {
   sudo apt clean "$@"
}

apt::search() {
   sudo apt search "$@"
}

apt::list() {
   sudo apt list "$@"
}

apt::info() {
   sudo apt show "$@"
}
