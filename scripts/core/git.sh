#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/main.sh"

git::inside_work_tree() {
   git rev-parse --is-inside-work-tree >/dev/null
}

git::current_branch() {
   git branch | grep \* | cut -d ' ' -f2
}

git::master_branch() {
   local branch="master"
   git branch | grep -q main || branch="main"
   echo "$branch"
}

git::root() {
   git rev-parse --show-toplevel
}
