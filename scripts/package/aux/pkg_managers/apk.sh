#!/usr/bin/env bash

apk::install() {
   apk add "$@"
}

apk::remove() {
   apk del "$@"
}

apk::update() {
   apk update "$@"
}

apk::upgrade() {
   apk upgrade "$@"
}

apk::clean() {
   apk clean "$@"
}

apk::search() {
   apk search "$@"
}

apk::list() {
   apk list "$@"
}

apk::info() {
   apk show "$@"
}
