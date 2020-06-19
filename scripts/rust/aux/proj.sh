#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/main.sh"
source "${DOTFILES}/scripts/core/platform.sh"
source "${DOTFILES}/scripts/core/log.sh"

_proj_name() {
   cat "${PROJ_HOME}/Cargo.toml" \
      | grep name \
      | head -n1 \
      | sed 's/name = //' \
      | tr -d '"'
}

case "${1:-}" in
   --help|-h) ;;
   *)
      export PROJ_HOME="${PROJ_HOME:-$PWD}"
      export PROJ_NAME="${PROJ_NAME:-$(_proj_name)}"
      ;;
esac