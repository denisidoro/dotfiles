#!/usr/bin/env bash

git::inside_work_tree() { 
   git rev-parse --is-inside-work-tree >/dev/null
}

git::current_branch() {
   git branch | grep \* | cut -d ' ' -f2
}

git::root() {
   git rev-parse --show-toplevel
}
