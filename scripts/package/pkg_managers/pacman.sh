#!/usr/bin/env bash

_pacman() {
   pacman --color=always "$@"
}

pacman::install() {
   sudo _pacman -S "$@"
}

pacman::remove() {
   sudo _pacman -R "$@"
}

pacman::update() {
   sudo _pacman -Sy "$@"
}

pacman::upgrade() {
   sudo _pacman -Syu "$@"
}

pacman::clean() {
   sudo _pacman clean "$@"
}

pacman::search() {
   sudo _pacman -Ss "$@"
}

pacman::list() {
   sudo _pacman -Q
}

pacman::info() {
   sudo _pacman -Qi "$@"
}
