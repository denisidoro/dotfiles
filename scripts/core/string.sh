#!/usr/bin/env bash
# vim: filetype=sh

function str::capitalize {
  echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}"
}

function str::contains() {
	if [[ "${1}" == *"${2}"* ]]; then
    	return 0
	else
	    return 1
	fi
}

function str::uppercase() {
  cat | tr '[:lower:]' '[:upper:]'
}

function str::trim_newlines() {
  tr -d "\n"
}

function str::last_word() {
  grep -oE '[^ ]+$'
}

function str::remove_last_char() {
  echo "${1:0:${#1}-1}"
}
