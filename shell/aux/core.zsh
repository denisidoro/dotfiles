#!/usr/bin/env bash
# vim: filetype=sh

function include() {
    [[ -f "$1" ]] && source "$1"
}

function indexof() { 
	local readonly index="$1"
		i=0; 
	shift
	while [ "$i" -le "$#" ]; do 
		if [ "${@:$i:1}" = "$index" ]; then
			echo $i
			return
		fi
		((i++)); 
	done; 
	echo -1; 
}

function nonzero_return() {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo "$RETVAL"
}

function dot_or_args() {
	local readonly dash_index="$(indexof "--" "$@")"
		readonly fn="${@:1:$((dash_index-1))}"
	shift $dash_index
	if [[ $# < 1 ]]; then 
		eval ${fn[@]} .
	else
		eval ${fn[@]} "$@"
	fi
}
