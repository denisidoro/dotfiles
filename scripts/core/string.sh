#!/usr/bin/env bash

function capitalize {
  echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}"
}

function contains_string() {
	if [[ "${1}" == *"${2}"* ]]; then
    	return 0
	else
	    return 1
	fi
}