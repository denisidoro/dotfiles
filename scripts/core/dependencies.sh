#!/usr/bin/env bash

function rsrc() {
   echo "$DOTFILES/scripts/$1"
}

function script_dir() {
   cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}
