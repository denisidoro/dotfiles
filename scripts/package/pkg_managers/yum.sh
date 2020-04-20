#!/usr/bin/env bash

yum::install() {
   sudo yum install "$@"
}

yum::remove() {
   sudo yum uninstall "$@"
}

yum::update() {
   sudo yum updateinfo "$@"
}

yum::upgrade() {
   sudo yum update "$@"
}

yum::clean() {
   sudo yum clean "$@"
}

yum::search() {
   sudo yum search "$@"
}

yum::list() {
   sudo yum list "$@"
}

yum::info() {
   sudo yum info "$@"
}
