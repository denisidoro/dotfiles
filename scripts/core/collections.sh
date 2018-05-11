#!/bin/user/env bash

function coll::is_empty() {
  local var=${1}
  [[ -z ${var} ]]
}

function coll::contains_element() {
  elements="${@:2}"
  element="${1}"

  for e in ${elements[@]}; do
    if [[ "$e" == "${element}" ]]; then
      return 1;
    fi
  done
  return 0
}
