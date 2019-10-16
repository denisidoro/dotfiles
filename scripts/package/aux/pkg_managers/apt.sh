#!/usr/bin/env bash

if platform::command_exists apt-get && ! platform::command_exists apt; then
   apt() {
      apt-get "$@"
   }

   export -f apt-get
fi

apt::install() {
   local -r ask="$(dict::get "$OPTIONS" ask)"
   apt install $([ ! $ask ] && echo "--yes") "$@"
}

apt::remove() {
   apt remove "$@"
}

apt::update() {
   apt update "$@"
}

apt::upgrade() {
   apt::update "$@" || true
   apt upgrade "$@"
}

apt::clean() {
   apt clean "$@"
}

apt::search() {
   apt search "$@"
}

apt::list() {
   apt list "$@"
}

apt::info() {
   apt show "$@"
}
