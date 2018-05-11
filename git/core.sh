#!/usr/bin/env bash
set -euo pipefail

source "$DOTFILES/scripts/core/main.sh"

function prompt_if_protected() {
	local current_branch="$1"
	local protected_branch="$2"
	
	if [ $protected_branch = $current_branch ]; then  
	    if ! feedback::confirmation "Are you sure you want to push to $protected_branch?" true; then
	    	exit 1
	    fi
	fi  
}

function check_json() {
	local files="$1"

	for file in $(echo "$files" | grep -P '\.((json))$'); do
		set +e
	    python -mjson.tool "$file" 2>&1 /dev/null
	    local result=$?
	    if [ $result -ne 0 ] ; then
	        not_commited_msg
	        error "Lint check of JSON object failed\n\tin $git_dir/$file"
	        python -mjson.tool "$file"
	        exit 1
	    fi
	    set -e
	done
}

function check_edn() {
	local files="$1"

	for file in $(echo "$files" | grep -P '\.((edn))$'); do
	    cat "$file" | dot clojure edn > /dev/null || {
	        error "Lint check of EDN object failed\n\tin ${git_dir}/${file}"
		    if ! feedback::confirmation "Are you sure you want to commit this file anyway?" false; then
		    	exit 2
		    fi
		}
	done
}

function match_content() {
	local files="$1"
	local name="$2"
	local pattern="$3"
	local stop="${4:-true}"

	for file in $(echo "$files"); do
		local res=$(cat "$file" | grep -E --line-number "$pattern");
		if [ -n "$res" ]; then
			$stop && { not_commited_msg; }
			error "$file matched the \"$name\" blacklist content regex:"
			echo "$res"
			if $stop; then		
			    if ! feedback::confirmation "Are you sure you want to commit anyway?" false; then
			    	exit 3
			    fi
			else
				commited_anyway_msg
			fi
		fi 
	done
}

function match_filename() {
	local files="$1"
	local name="$2"
	local pattern="$3"
	local stop="${4:-true}"

	for file in $(echo "$files"); do
		local res=$(echo "$file" | grep -E "$pattern");
		if [ -n "$res" ]; then
			$stop && { not_commited_msg; }
			error "$file matched the \"$name\" blacklist filename regex:"

			if $stop; then		
			    if ! feedback::confirmation "Are you sure you want to commit anyway?" false; then
			    	exit 4
			    fi
			else
				commited_anyway_msg
			fi
		fi 
	done
}

function check_aws() {
	local files="$1"

	match_content "$files" "AWS key ID" "[^A-Z0-9][A-Z0-9]{20}[^A-Z0-9]" true
	match_content "$files" "AWS key" "[^A-Za-z0-9/+=][A-Za-z0-9/+=]{40}[^A-Za-z0-9/+=]" true
}

function check_conflict() {
	local files="$1"

	for file in $(echo "$files"); do
		local res=$(echo "$file" | egrep '^[><=]{7}( |$)' -H -I --line-number && echo 0 || echo 1)
		if [ $res == 0 ]; then
			error "$file still has unresolved conflicts"
		    exit 5
		fi
	done
}

function not_commited_msg() {
	error "Your changes were not commited"
}

function commited_anyway_msg() {
	warning "Your changes were commited anyway"
}
