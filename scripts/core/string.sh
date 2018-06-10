#!/usr/bin/env bash

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

function str::trim_newlines() {
  tr -d "\n"
}