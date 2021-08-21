#!/usr/bin/env bash

_pacman() {
   sudo pacman --color=always "$@"
}

pacman::install() {
   _pacman -S "$@"
}

pacman::remove() {
   _pacman -R "$@"
}

pacman::update() {
   _pacman -Sy "$@"
}

pacman::upgrade() {
   _pacman -Syu "$@"
}

pacman::clean() {
   _pacman clean "$@"
}

pacman::search() {
   _pacman -Ss "$@"
}

pacman::list() {
   _pacman -Q
}

pacman::info() {
   _pacman -Qi "$@"
}
