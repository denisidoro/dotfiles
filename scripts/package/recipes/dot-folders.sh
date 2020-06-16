#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   return 1
}

package::install() {
    mkdir -p "${DOTFILES}/local" 2>/dev/null || true
    mkdir -p "${DOTFILES}/local/tmp" 2>/dev/null || true
    mkdir -p "${DOTFILES}/local/bin" 2>/dev/null || true
    mkdir -p "${DOTFILES}/target" 2>/dev/null || true
    mkdir -p "${DOTFILES}/bin" 2>/dev/null || true

mkdir -p "$(fs::tmp)" 2>/dev/null || true
mkdir -p "$(fs::bin)" 2>/dev/null || true
}
