#!/usr/bin/env bash
# vim: filetype=sh

navi::map() {
   dict::new brew denisidoro/tools/navi
}

navi::depends_on() {
   coll::new fzf
}

navi::install() {
   recipe::install_from_git "https://github.com/denisidoro/navi"
}