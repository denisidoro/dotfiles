#!/data/data/com.termux/files/usr/bin/env bash

export DOTFILES="${DOTFILES:-"${HOME}/dotfiles"}"
export SDCARD_TASKER="${SDCARD_TASKER:-"/sdcard/Tasker"}"
export SDCARD_DOTFILES="${SDCARD_DOTFILES:-"/sdcard/dotfiles"}"

export PREFIX="/data/data/com.termux/files/usr"
export LD_LIBRARY_PATH="${PREFIX}/lib"
export LD_PRELOAD="${LD_LIBRARY_PATH}/libtermux-exec.so"
export PATH="${PATH:-}:${PREFIX}/bin"
export LANG="en_US.UTF-8"
export SHELL="${PREFIX}/bin/bash"
export TERM="dumb"

exec "$SHELL" -l
termux-chroot || true

_script() {
   local -r path="$1"
   shift
   bash "$path" "$@" 
}

_dot() {
   "${DOTFILES}/bin/dot" "$@"
}

_eval() {
   eval "$*"
}

_main() {
   local -r cmd="${1:-}"
   shift
   case "$cmd" in
      eval) _eval "$@" ;;
      script) _script "$@" ;;
      dot) _dot "$@" ;;
      *) exit 2 ;;
   esac
}

_main "$@"
