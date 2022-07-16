#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES}/scripts/core/main.sh"

# =====================
# main
# =====================

if [ -z "${PROJ_NAME:-}" ]; then
   die "PROJ_NAME is empty"
fi

export PROJ_BIN_NAME="${PROJ_BIN_NAME:-$PROJ_NAME}"

export PROJ_HOME="${PROJ_HOME:-"$(pwd)"}"

# =====================
# android
# =====================

export ANDROID_HOST="${ANDROID_HOST:-192.168.0.12}"
export ANDROID_PORT="${ANDROID_PORT:-8022}"


# =====================
# paths
# =====================

export CARGO_DEFAULT_BIN="${HOME}/.cargo/bin"
export BIN_DIR="${BIN_DIR:-"$CARGO_DEFAULT_BIN"}"
