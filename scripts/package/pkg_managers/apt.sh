#!/usr/bin/env bash

_apt() {
   set -x
   apt-get "$@"
}

apt::install() {
   local ask=false # TODO
   if ! $ask; then unset ask; fi
   _apt install ${ask:+ "--yes"} "$@"
}

apt::remove() {
   _apt remove "$@"
}

apt::update() {
   _apt update "$@"
}

apt::upgrade() {
   apt::update "$@" || true
   _apt upgrade "$@"
}

apt::clean() {
   _apt clean "$@"
}

apt::search() {
   _apt search "$@"
}

apt::list() {
   _apt list "$@"
}

apt::info() {
   _apt show "$@"
}
