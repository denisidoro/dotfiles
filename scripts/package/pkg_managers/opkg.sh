#!/usr/bin/env bash

opkg::install() {
   opkg install "$@"
}

opkg::remove() {
   opkg uninstall "$@"
}

opkg::update() {
   opkg update "$@"
}

opkg::upgrade() {
   opkg upgrade "$@"
}

opkg::clean() {
   opkg clean "$@"
}

opkg::search() {
   opkg search "$@"
}

opkg::list() {
   opkg list "$@"
}

opkg::info() {
   opkg info "$@"
}
