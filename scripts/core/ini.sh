#!/usr/bin/env bash

ini::get() {
  local -r key="$1"

  grep -A999 "\[${key}\].*" \
    | sed '/^ *$/q' \
    | tail -n +2
}