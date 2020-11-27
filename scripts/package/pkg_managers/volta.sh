#!/usr/bin/env bash

volta::install() {
   volta install "$@"
}

volta::remove() {
   volta uninstall "$@"
}

volta::update() {
   volta update "$@"
}

volta::upgrade() {
   volta upgrade "$@"
}

volta::clean() {
   volta clean "$@"
}

volta::search() {
   volta search "$@"
}

volta::list() {
   volta list "$@"
}

volta::info() {
   volta info "$@"
}
