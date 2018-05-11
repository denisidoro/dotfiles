#!/usr/bin/env bash

function string::capitalize {
  echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}"
}

function string::contains() {
	if [[ "${1}" == *"${2}"* ]]; then
    	return 0
	else
	    return 1
	fi
}