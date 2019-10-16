#!/usr/bin/env bash
# vim: filetype=sh

gnu::is_installed() {
  platform::command_exists ggrep
}

gnu::install() {
  if ! platform::is_osx; then
     log::warning "No need to install gnu utils in a platform which is not OSX"
     return 0
  fi

  brew tap homebrew/dupes
  brew install binutils diffutils findutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gzip wget
  brew install wdiff --with-gettext
  brew install m4 make nano file-formula
}