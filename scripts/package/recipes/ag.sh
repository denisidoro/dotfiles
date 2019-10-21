#!/usr/bin/env bash
# vim: filetype=sh

ag::map() {
   dict::new \
      brew the_silver_searcher \
      port the_silver_searcher \
      apt silversearcher-ag \
      yum the_silver_searcher \
      dnf the_silver_searcher \
      yum the_silver_searcher \
      emerge sys-apps/the_silver_searcher \
      pacman the_silver_searcher \
      sbopkg the_silver_searcher \
      zypper the_silver_searcher \
      pkg the_silver_searcher
}

ag::install() {
   recipe::install_from_git "https://github.com/ggreer/the_silver_searcher"
}