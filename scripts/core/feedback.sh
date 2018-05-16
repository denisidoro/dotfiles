#!/usr/bin/env bash

function feedback::confirmation() {
	local msg="$1"
	local default_yes="${2:-true}"
	local options
	
	if $default_yes; then
		options="(Y|n)"
	else
		options="(y|N)"
	fi

    read -p "$msg $options " -n 1 -r < /dev/tty
    local reply="$REPLY"

    if [[ -z "$reply" ]]; then
    	if $default_yes; then
    		return 0
    	else
    		return 1
    	fi
    fi

    echo
    if echo "$reply" | grep -E '^[Yy]$' > /dev/null; then
    	return 0
    else
    	return 1
    fi
}
