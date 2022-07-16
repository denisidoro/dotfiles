#!/usr/bin/env bash

yum::install() {
   yum install "$@"
}

yum::remove() {
   yum uninstall "$@"
}

yum::update() {
   yum updateinfo "$@"
}

yum::upgrade() {
   yum update "$@"
}

yum::clean() {
   yum clean "$@"
}

yum::search() {
   yum search "$@"
}

yum::list() {
   yum list "$@"
}

yum::info() {
   yum info "$@"
}
