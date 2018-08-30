#!/usr/bin/env bash

function extract_help() {
    local file="$1"
    grep "^##?" "$file" | cut -c 5-
}

function docs::eval() {
    local readonly file="$0"
    local readonly help="$(extract_help "$file")"
    if platform::command_exists "python"
      docopts="$DOTFILES/scripts/core/docopts"
    else
      docopts="$DOTFILES/modules/docoptsh/docoptsh"
    fi
    if [[ ${1:-} = "--version" ]]; then
        local readonly version_code=$(grep "^ #?" "$file" | cut -c 5- || echo "unversioned")
        local readonly git_info=$(cd "$(dirname "$file")" && git log -n 1 --pretty=format:'%h%n%ad%n%an%n%s' --date=format:'%Y-%m-%d %Hh%M' -- "$(basename "$file")")
        local readonly version="$(echo -e "${version_code}\n${git_info}")"
        eval "$($docopts -h "${help}" -V "${version}" : "${@:1}")"
    else
        eval "$($docopts -h "${help}" : "${@:1}")"
    fi
}
