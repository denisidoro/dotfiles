#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

log::warning "FASD has been deprecated! Installing z.lua instead..."
echo

dot pkg add zlua