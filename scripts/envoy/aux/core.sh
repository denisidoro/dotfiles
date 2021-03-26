#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/main.sh"
source "${DOTFILES}/scripts/core/log.sh"
source "${DOTFILES}/scripts/core/feedback.sh"
source "${DOTFILES}/scripts/core/git.sh"

export USER="$(whoami)"
export LOCAL_ENVOY="${WORK_HOME}/infra/envoy-oss"
export ENVOY_MUTABLE_DIR="envoy_mutable"
export REMOTE_ENVOY="${HOME}/envoy"
export REMOTE_ENVOY_MUTABLE="${HOME}/${ENVOY_MUTABLE_DIR}"

if [ -n "${ENVOY_IP:-}" ]; then
   export IP="$ENVOY_IP"
fi

platform::is_local() {
   uname -a | grep -q arwin
}

platform::validate_local() {
   platform::is_local || die "This call must be made locally"
} 

platform::validate_remote() {
   platform::is_local && die "This call must be made remotely"
} 

envoy::rm_symlink() {
   if platform::is_local; then
      rm "envoy" || true
   else 
      rm "${REMOTE_ENVOY}/envoy" || true
      rm "${REMOTE_ENVOY_MUTABLE}/envoy" || true
   fi
}

envoy::rm_symlink &>/dev/null