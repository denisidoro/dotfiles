#!/usr/bin/env bash

symlink_bashrc() {
   cd "$DOTFILES"
   local -r bashrc_path="$(cat "links/unix.yaml" | grep bashrc | cut -d',' -f1)"
   source "$bashrc_path"
}

test::set_suite "bash - bashrc"
test::skip "sourcing the bashrc won't bork" symlink_bashrc