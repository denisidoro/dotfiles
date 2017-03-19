#!/usr/bin/env bash
# vim: filetype=sh

set -e -o pipefail

function command_exists() {
  type "$1" &> /dev/null ;
}

function is_empty() {
  local var=${1}
  [[ -z ${var} ]]
}

function is_file() {
  local file=${1}
  [[ -f ${file} ]]
}

function is_dir() {
  local dir=${1}
  [[ -d ${dir} ]]
}

function containsElement() {
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

function getHelpString() {
  grep "^##?" "$1" | cut -c 5-
}

function getHelp() {
  getHelpString "$0"
}

function getCommands() {
  ls ${1}.d | grep -ve ".*\.sh"
}

function eval_opts() {
  local help="${1}"
  shift
  eval "$($DOTFILES/scripts/aux/docopts -h "${help}" : "${@}")"
}

function validateCommand() {
  commad="${1}"
  commands="${@:2}"

  if containsElement ${command} "${commands}"; then
    echo "Available Commands: "
    echo "${commands}"
    fail "Invalid command ${command}"
    exit 1
  fi
}

function capitalize {
  echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}"
}

function program_is_installed {
  local return_=1
  type $1 >/dev/null 2>&1 || { local return_=0; }
  echo "$return_"
}

function is_osx {
  [[ `uname -s` == "Darwin" ]]
}

