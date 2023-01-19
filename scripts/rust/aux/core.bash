#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES}/scripts/core/main.sh"

todo_doc() {
   echo "TODO: proper documentation for this Rust util  
   
Usage:
  $0"
}

case "${1:-}" in
   -h|--help) todo_doc "$@"; exit 0 ;;
esac

# =====================
# main
# =====================

if [ -z "${PROJ_NAME:-}" ]; then
   die "PROJ_NAME is empty"
fi

export PROJ_BIN_NAME="${PROJ_BIN_NAME:-$PROJ_NAME}"

export PROJ_HOME="${PROJ_HOME:-"$(pwd)"}"

# =====================
# paths
# =====================

export CARGO_DEFAULT_BIN="${HOME}/.cargo/bin"
export BIN_DIR="${BIN_DIR:-"$CARGO_DEFAULT_BIN"}"
