#!/usr/bin/env bash

npm::cmd() {
   if has yarn; then
      echo yarn
      return 0
   elif has npm; then
      echo npm
      return 0
   fi

   dot pkg add yarn
   echo yarn
}

dot::clone() {
   local -r DOTFILES_COMMIT_HASH="e517c25"
   git clone "https://github.com/denisidoro/dotfiles.git" "$DOTFILES"
   cd "$DOTFILES" || exit
   git checkout "$DOTFILES_COMMIT_HASH"
}

dot::install_if_necessary() {
   [ -n "${DOTFILES:-}" ] && [ -x "${DOTFILES}/bin/dot" ] && return
   export DOTFILES="${PROJ_HOME}/dotfiles"
   export PATH="${DOTFILES}/bin:${PATH}"
   [ -n "${DOTFILES:-}" ] && [ -x "${DOTFILES}/bin/dot" ] && return
   dot::clone 2>/dev/null || true
}

export PROJ_HOME="${PROJ_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"
export PROJ_NAME="klapaucius"

klap() {
   local -r fn="$1"
   shift
   "${PROJ_HOME}/scripts/${fn}" "$@"
}

export -f klap

dot::install_if_necessary
source "${DOTFILES}/scripts/core/main.sh"
source "${DOTFILES}/scripts/core/log.sh"