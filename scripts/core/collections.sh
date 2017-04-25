#!/bin/user/env bash

function is_empty() {
  local var=${1}
  [[ -z ${var} ]]
}

function contains_element() {
  elements="${@:2}"
  element="${1}"

  for e in ${elements[@]}; do
    if [[ "$e" == "${element}" ]]; then
      return 1;
    fi
  done
  return 0
}

function contains_string() {
  echo "${1}" | grep "${2}" -q
  echo $?
}

