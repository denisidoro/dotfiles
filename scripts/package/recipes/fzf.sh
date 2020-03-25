#!/usr/bin/env bash
# vim: filetype=sh

fzf::map() {
   dict::new \
      brew fzf \
      pkg fzf
}

fzf::map() {
   platform::command_exists brew && brew install fzf && return 0

   recipe::shallow_github_clone junegunn fzf
   cd "$TMP_DIR/fzf"
   yes | ./install
}
