# ===============
# explorer
# ===============

alias o="dot_or_args open --"
alias r="dot_or_args ranger --"

# ===============
# listing
# ===============

#alias ls='ls --color=auto'
alias lst="tree -L 2"

# ===============
# folders
# ===============

mkcd() {
    mkdir -p -- "$@" && cd -P -- "$@"
}

# ===============
# helpers
# ===============

function _fzf() {
    fzf +m
}

function _best_match() {
    local lines="$1"
    shift
    echo "$lines" \
        | fzf --filter="$*" \
        | head -n1
}

function _list_files() {
    ag --hidden --ignore .git -g "${1:-}"
}

function _list_folders() {
    _list_files \
        | xargs dirname \
        | sort -u
}

function _action_from_fasd() {
  local fasd_args="$1"
  local cmd="$2"
  local selection=$(fasd "$fasd_args" \
    | awk '{print $2}' \
    | _fzf) \
    && [ -n "$selection" ] \
    && "$cmd" "$selection"
}

function _cd_file() {
    cd "$(dirname "$1")"
}

function _jj() {
    local cmd="$1"
    local lines="$2"
    shift 2
    if [ $# -gt 0 ]; then
        "$cmd" "$(_best_match "$lines" "$@")" 
    else
        local selection=$(echo "$lines" | _fzf) \
            && [ -n "$selection" ] \
            && "$cmd" "$selection"
    fi
}

# ===============
# jumping
# ===============

j() { 
    [ $# -gt 0 ] && \
        fasd_cd -d "$@" \
        || _action_from_fasd -d "cd" 
}

jj() { 
    _jj cd "$(_list_folders)" "$@" 
}

jjf() { 
    _jj _cd_file "$(_list_files)" "$@" 
}

jv() { 
    [ $# -gt 0 ] && \
        fasd -f -e nvim "$@" \
        || _action_from_fasd -f nvim 
}

jjv() { 
    _jj nvim "$(_list_files)" "$@" 
}

js() { 
    [ $# -gt 0 ] && \
        fasd -f -e subl "$@" \
        || _action_from_fasd -f subl 
}

jjs() {
    _jj subl "$(_list_files)" "$@" 
}

# Go up X directories (default 1)
up() {
    if [[ "$#" -ne 1 ]]; then
        cd ..
    elif ! [[ $1 =~ '^[0-9]+$' ]]; then
        echo "Error: up should be called with the number of directories to go up. The default is 1."
    else
        local d=""
        limit=$1
        for ((i=1 ; i <= limit ; i++))
        do
            d=$d/..
        done
        d=$(echo $d | sed 's/^\///')
        cd $d
    fi
}

# Go up to project root
jr() { 
    cd "$(git rev-parse --show-toplevel)" 
}
