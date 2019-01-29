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

function cd::fzf() {
    fzf +m
}

function cd::best_match() {
    local lines="$1"
    shift
    echo "$lines" \
        | fzf --filter="$*" \
        | head -n1
}

function cd::list_files() {
    ag --hidden --ignore .git -g "${1:-}"
}

function cd::list_folders() {
    cd::list_files \
        | xargs -n1 dirname \
        | sort -u
}

function cd::action_from_fasd() {
  local fasd_args="$1"
  local cmd="$2"
  local selection=$(fasd "$fasd_args" \
    | awk '{print $2}' \
    | cd::fzf) \
    && [ -n "$selection" ] \
    && "$cmd" "$selection"
}

function cd::cd_file() {
    cd "$(dirname "$1")"
}

function cd::jj() {
    local cmd="$1"
    local lines="$2"
    shift 2
    if [ $# -gt 0 ]; then
        "$cmd" "$(cd::best_match "$lines" "$@")" 
    else
        local selection=$(echo "$lines" | cd::fzf) \
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
        || cd::action_from_fasd -d "cd" 
}

jj() { 
    cd::jj cd "$(cd::list_folders)" "$@" 
}

jjf() { 
    cd::jj _cd_file "$(cd::list_files)" "$@" 
}

jv() { 
    [ $# -gt 0 ] && \
        fasd -f -e nvim "$@" \
        || cd::action_from_fasd -f nvim 
}

jjv() { 
    cd::jj nvim "$(cd::list_files)" "$@" 
}

js() { 
    [ $# -gt 0 ] && \
        fasd -f -e subl "$@" \
        || cd::action_from_fasd -f subl 
}

jjs() {
    cd::jj subl "$(cd::list_files)" "$@" 
}

jn() {
    cd "$WORK_HOME" && cd::jj cd "$(ls "$WORK_HOME")" "$@"
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
