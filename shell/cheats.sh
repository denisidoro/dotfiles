#!/usr/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Edit deployment
# kubectl edit deployment <deployment> --namespace <namespace>

# CHEAT_CONFIG_FOLDER="${CHAT_CONFIG_FOLDER:-"$HOME/.config/cheat"}"
CHEAT_CONFIG_FOLDER="${CHEAT_CONFIG_FOLDER:-"${DIR}/cheats"}"

io::config_files() {
	find "$CHEAT_CONFIG_FOLDER" -iname '*.sh'
}

str::last_paragraph_line() {
	awk '(!NF) { exit } { print $0}' \
        | tail -n1
}

parser::command() {
	local readonly filepath="$1"
	local readonly query="$2"

	grep "$filepath" "$query" -A50 \
		| str::last_paragraph_line
}

parser::first_arg() {
	grep -Eo '<[0-9a-zA-Z\-_]+>' \
      | head -n1 \
	  | tr -d '<' \
	  | tr -d '>'
}

parser::has_arg() {
	parser::first_arg
}

parser::is_comment() {
    grep -qE '^#'
}

io::read() {
    for file in $(cat); do
        awk '
        function color(c,s) {
           printf("\033[%dm%s\033[0m",30+c,s)
        }
        
        /^%/ { suffix=" ["substr($0, 3)"]"; next }
        /^#/ { print color(1, $0) color(6, suffix); next }
        NF { print color(7, $0) color(6, suffix); next }' "$file"
    done
}

parser::explode() {
    sed -E 's/(.*) \[(.*)\].*/\1£\2/g'
}

ui::select() {
    io::config_files \
        | io::read \
        | fzf -i --ansi \
        | parser::explode
}

parser::command() {
    local readonly selection="$1"

    core="$(echo $selection | cut -d'£' -f1)"
    tags="$(echo $selection | cut -d'£' -f2)"

    if echo "$core" | parser::is_comment; then
        for file in $(io::config_files); do
        if grep -q "% $tags" "$file"; then
            grep "$core" "$file" -A50 \
              | str::last_paragraph_line
        fi
        done
    else
        echo "$core"
    fi
}

selection="$(ui::select)"
cmd="$(parser::command "$selection")"
echo "$cmd"

while true; do
    arg="$(echo "$cmd" | parser::first_arg || echo "")"
    if [ -z "$arg" ]; then 
      break
    fi
    case "$arg" in
        branch) value="$(git branch --format='%(refname:short)' | fzf)";;
    esac
    cmd="$(echo "$cmd" | sed "s|<${arg}>|${value}|")"
done

echo "$cmd"