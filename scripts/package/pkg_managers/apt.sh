#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/dict.sh"

_apt() {
   apt-get "$@"
}

apt::install() {
   local -r ask="$(dict::get "$OPTIONS" ask || false)"
   _apt install $([ ! "$ask" ] && echo "--yes") "$@"
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
