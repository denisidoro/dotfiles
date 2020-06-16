#!/usr/bin/env bash

if ! ${DOT_MAIN_SOURCED:-false} ; then
   source "${DOTFILES}/scripts/core/misc.sh"
   source "${DOTFILES}/scripts/core/platform.sh"
   source "${DOTFILES}/scripts/core/osx_gnu.sh"

   if ! ${DOT_EXPORTED_PATH:-false}; then
      if ! platform::command_exists dot; then
         export PATH="${DOTFILES}/bin/:${PATH}"
         export DOT_EXPORTED_PATH=true
      fi

      if ! platform::command_exists sudo; then
         sudo() { "$@"; }
         export -f sudo
      fi

      export EDITOR="${EDITOR:-vi}"
   fi

   source "${DOTFILES}/scripts/core/collections.sh"
   source "${DOTFILES}/scripts/core/log.sh"
   source "${DOTFILES}/scripts/core/documentation.sh"
   source "${DOTFILES}/scripts/core/filesystem.sh"
   source "${DOTFILES}/scripts/core/string.sh"
   source "${DOTFILES}/scripts/core/feedback.sh"
   readonly DOT_MAIN_SOURCED=true
fi

if ${DOT_TRACE:-false}; then
   export PS4='+'$'\t''\e[1;30m\t \e[1;39m$(printf %4s ${SECONDS}s) \e[1;31m$(printf %3d $LINENO) \e[1;34m$BASH_SOURCE \e[1;32m${FUNCNAME[0]:-}\e[0m: '
   set -x
fi
