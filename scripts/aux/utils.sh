#!/usr/bin/env bash
# vim: filetype=sh

set -e -o pipefail

function rsrc() {
  echo "$DOTFILES/scripts/$1"
}

function command_exists() {
  type "$1" &> /dev/null ;
}

function script_dir() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
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

function get_help_string() {
  grep "^##?" "$1" | cut -c 5-
}

function get_commands() {
  ls ${1}.d | grep -ve ".*\.sh"
}

function eval_opts() {
  local help="${1}"
  shift
  eval "$($DOTFILES/scripts/aux/docopts -h "${help}" : "${@}")"
}

function eval_docopts() {
  local help=$(get_help_string "$0")
  eval_opts "$help" "$@"
}

function validate_command() {
  commad="${1}"
  commands="${@:2}"

  if contains_element ${command} "${commands}"; then
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

function get_platform() {
  case "$(uname -s)" in
    Darwin)
      echo osx
      ;;
    *)
      if command_exists apt
      then
	echo apt
      fi
      ;;
  esac
}

function read_dependencies() {
  local url file tmpfile
  file=$(rsrc "dependencies.txt")
  echo "$(cat "$file")\n\n"
}

function from_dependencies() {
  for key in "$@"
  do
    echo "$dependencies" | grep -Pzo "^$key:\n(.|\n)*?\n{2}" | tail -n +2 | sed '/^$/d'             	 
  done
}
