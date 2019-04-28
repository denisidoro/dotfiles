#!/usr/bin/env bash

git::current_branch() {
   git branch | grep \* | cut -d ' ' -f2
}

git::root() {
   git rev-parse --show-toplevel
}
