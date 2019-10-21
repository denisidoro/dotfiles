#!/usr/bin/env bash

_npm() {
   npm -g "$@"
}

npm::install() {
   _npm install "$@"
}

npm::remove() {
   _npm uninstall "$@"
}

npm::update() {
   _npm update "$@"
}

npm::upgrade() {
   _npm upgrade "$@"
}

npm::clean() {
   _npm clean "$@"
}

npm::search() {
   _npm search "$@"
}

npm::list() {
   _npm list "$@"
}

npm::info() {
   _npm info "$@"
}
