#!/usr/bin/env bash

if [ -z ${DOT_MAIN_IMPORTED+x} ] || ! "${DOT_MAIN_IMPORTED}"; then
   source "${DOTFILES}/scripts/core/platform.sh"
   source "${DOTFILES}/scripts/core/osx_gnu.sh"
   source "${DOTFILES}/scripts/core/collections.sh"
   source "${DOTFILES}/scripts/core/log.sh"
   source "${DOTFILES}/scripts/core/dependencies.sh"
   source "${DOTFILES}/scripts/core/documentation.sh"
   source "${DOTFILES}/scripts/core/filesystem.sh"
   source "${DOTFILES}/scripts/core/string.sh"
   source "${DOTFILES}/scripts/core/feedback.sh"
   readonly DOT_MAIN_IMPORTED=true
fi
