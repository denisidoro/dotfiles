#!/usr/bin/env bash

pkg::install() {
   pkg install "$@"
}

pkg::remove() {
   pkg uninstall "$@"
}

pkg::update() {
   pkg update "$@"
}

pkg::upgrade() {
   pkg upgrade "$@"
}

pkg::clean() {
   pkg clean "$@"
}

pkg::search() {
   pkg search "$@"
}

pkg::list() {
   pkg list "$@"
}

pkg::info() {
   pkg info "$@"
}
