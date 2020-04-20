#!/usr/bin/env bash

pip::install() {
   pip install "$@"
}

pip::remove() {
   pip uninstall "$@"
}

pip::update() {
   pip update "$@"
}

pip::upgrade() {
   pip upgrade "$@"
}

pip::clean() {
   pip clean "$@"
}

pip::search() {
   pip search "$@"
}

pip::list() {
   pip list "$@"
}

pip::info() {
   pip info "$@"
}
