#!/usr/bin/env bash
# vim: filetype=sh

spacemacs::is_installed() {
  ls ~/.emacs.d/ | grep -q spacemacs > /dev/null
} 

spacemacs::install() {
  git clone https://github.com/syl20bnr/spacemacs --depth 1 ~/.emacs.d
}
