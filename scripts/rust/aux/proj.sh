#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/main.sh"

_proj_name() {
    cat "${PROJ_HOME}/Cargo.toml" \
        | grep name \
        | head -n1 \
        | sed 's/name = //' \
        | tr -d '"'
}

export PROJ_HOME="${PROJ_HOME:-$PWD}"
export PROJ_NAME="${PROJ_NAME:-$(_proj_name)}"