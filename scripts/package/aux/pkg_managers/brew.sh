#!/usr/bin/env bash

brew::install() {
   brew install "$@"
}

brew::remove() {
   brew uninstall "$@"
}

brew::update() {
   brew update "$@"
}

brew::upgrade() {
   brew upgrade "$@"
}

brew::clean() {
   brew clean "$@"
}

brew::search() {
   brew search "$@"
}

brew::list() {
   brew list "$@"
}

brew::info() {
   brew info "$@"
}
