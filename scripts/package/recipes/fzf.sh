#!/usr/bin/env bash
# vim: filetype=sh

fzf::map() {
   dict::new \
      brew fzf \
      pkg fzf
}

fzf::map() {
   recipe::shallow_github_clone junegunn fzf
   cd "$TMP_DIR/fzf"
   ./install

   # $(brew --prefix)/opt/fzf/install
}
