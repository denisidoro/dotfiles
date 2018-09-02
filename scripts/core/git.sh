#!/usr/bin/env bash

function git::current_branch() {
   git branch | grep \* | cut -d ' ' -f2
}

function git::root() {
   git rev-parse --show-toplevel
}
