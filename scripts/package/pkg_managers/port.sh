#!/usr/bin/env bash

port::install() {
   port install "$@"
}

port::remove() {
   port uninstall "$@"
}

port::update() {
   port update "$@"
}

port::upgrade() {
   port upgrade "$@"
}

port::clean() {
   port clean "$@"
}

port::search() {
   port search "$@"
}

port::list() {
   port list "$@"
}

port::info() {
   port info "$@"
}
