include() {
    [[ -f "$1" ]] && source "$1"
}

dot_or_args() {
	local readonly fn="$1"
	shift
	if [[ $# < 1 ]]; then 
		"$fn" .
	else
		"$fn" "$@"
	fi
}
