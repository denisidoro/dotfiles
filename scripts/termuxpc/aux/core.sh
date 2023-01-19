#!/usr/bin/env bash
source "${DOTFILES}/scripts/core/main.sh"
source "${DOTFILES}/scripts/termux/aux/universal.sh"

TERMUX_USER="${TERMUX_USER:-"u0_a357"}"
TERMUX_IP="${TERMUX_IP:-"192.168.0.5"}"
TERMUX_PORT="${TERMUX_PORT:-"8022"}"
TERMUX_ADDRESS="${TERMUX_USER}@${TERMUX_IP}"

run_cmd() {
   debug ssh "$TERMUX_ADDRESS" -p "$TERMUX_PORT" "$*"
}