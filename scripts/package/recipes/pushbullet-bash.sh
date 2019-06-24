#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

PUSHBULLET_HOME="${PUSHBULLET_HOME:-${DOTFILES}/modules/pushbullet}"
git clone https://github.com/Red5d/pushbullet-bash.git "$PUSHBULLET_HOME" --depth 1 || true
