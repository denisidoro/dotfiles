#!/usr/bin/env bash
# vim: filetype=sh

recipe::install() {
   platform::command_exists apt && dot pkg proxy apt add silversearcher-ag && return 0
   platform::command_exists pkg && dot pkg proxy pkg add the_silver_searcher && return 0
   platform::command_exists brew && brew install the_silver_searcher && return 0
   recipe::install_from_git "https://github.com/ggreer/the_silver_searcher"
}