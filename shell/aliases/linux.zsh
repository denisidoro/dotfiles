#!/usr/bin/env bash
# vim: filetype=sh

open() {
   dot system open "$@"
}

pbcopy() {
   dot system clip copy
}

pbpaste() {
   dot system clip paste
}
