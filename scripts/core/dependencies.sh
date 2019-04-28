#!/usr/bin/env bash

rsrc() {
   echo "$DOTFILES/scripts/$1"
}

script_dir() {
   cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}
