#!/usr/bin/env bash
# vim: filetype=sh

lua::apt() {
  VERSION=5.3
  luacmd="lua${VERSION}"
  sudo apt-get install "$luacmd"
  sudo mv "$luacmd" "$(fs::bin)/lua"
}
