#!/usr/bin/env bash
source "${DOTFILES}/scripts/core/main.sh"

TERMUX_ROOT="/data/data/com.termux/files"
# shellcheck disable=SC2034
TERMUX_HOME="${TERMUX_ROOT}/home"
TASKER="${TASKER:-"/sdcard/Tasker"}"
TASKER_TMP="${TASKER_TMP:-"${TASKER}/tmp"}"
SDCARD_DOTFILES="${SDCARD_DOTFILES:-"/sdcard/dotfiles"}"
export PREFIX="/data/data/com.termux/files/usr"
