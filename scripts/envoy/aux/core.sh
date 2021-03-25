#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/main.sh"
source "${DOTFILES}/scripts/core/log.sh"
source "${DOTFILES}/scripts/core/git.sh"

export USER="$(whoami)"
export ENVOY="${HOME}/envoy"
export ENVOY_MUTABLE="${HOME}/envoy_mutable"

platform::is_local() {
   uname -a | grep -q arwin
}

platform::validate_local() {
   platform::is_local || die "This must be called locally"
} 

platform::validate_remote() {
   platform::is_local && die "This must be called remotely"
} 

envoy::rm_symlink() {
   if platform::is_local; then
      rm "envoy" || true
   else 
      rm "${ENVOY}/envoy" || true
      rm "${ENVOY_MUTABLE}/envoy" || true
   fi
}

envoy::rm_symlink