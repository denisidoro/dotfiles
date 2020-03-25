#!/usr/bin/env bash

_apt() {
   apt-get "$@"
}

apt::install() {
   local -r ask="$(dict::get "$OPTIONS" ask)"
   sudo _apt install $([ ! $ask ] && echo "--yes") "$@"
}

apt::remove() {
   sudo _apt remove "$@"
}

apt::update() {
   sudo _apt update "$@"
}

apt::upgrade() {
   apt::update "$@" || true
   sudo _apt upgrade "$@"
}

apt::clean() {
   sudo _apt clean "$@"
}

apt::search() {
   sudo _apt search "$@"
}

apt::list() {
   sudo _apt list "$@"
}

apt::info() {
   sudo _apt show "$@"
}
