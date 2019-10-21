#!/usr/bin/env bash
# vim: filetype=sh

symlink_bashrc() {
   cd "$DOTFILES"
   bashrc_path="$(cat "symlinks/conf.yaml" | grep bashrc | awk '{print $2}')"
   source "$bashrc_path"
}

test::set_suite "bashrc"
test::skip "symlinks include bashrc" symlink_bashrc