#!/usr/bin/env bash

symlink_bashrc() {
   cd "$DOTFILES" || exit
   local -r bashrc_path="$(grep bashrc "links/unix.yaml" | cut -d',' -f1)"
   # shellcheck disable=SC1090
   source "$bashrc_path"
}

test::set_suite "bash | bashrc"
test::skip "sourcing the bashrc won't bork" symlink_bashrc