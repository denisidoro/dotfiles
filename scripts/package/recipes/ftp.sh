#!/usr/bin/env bash
# vim: filetype=sh

ftp::map() {
  dict::new brew inetutils
}

ftp::install() {
  dot pkg add --no-custom ftp && return 0 || true
}

