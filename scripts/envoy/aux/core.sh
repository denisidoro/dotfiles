#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/main.sh"
source "${DOTFILES}/scripts/core/log.sh"
source "${DOTFILES}/scripts/core/feedback.sh"
source "${DOTFILES}/scripts/core/git.sh"

export USER="$(whoami)"
export REMOTE_ENVOY_DIRNAME="envoy"
export REMOTE_ENVOY_DIR="${HOME}/${REMOTE_ENVOY_DIRNAME}"
export LOCAL_ENVOY_DIR="${WORK_HOME:-"/tmp/envoy"}/infra/envoy-oss"

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
   rm -rf "$(envoy::dir)/envoy" || true
}

envoy::dir() {
   if platform::is_local; then
      echo "$LOCAL_ENVOY_DIR"
   else
      echo "$REMOTE_ENVOY_DIR"
   fi
}

bazel::output_base_dir() {
   bazel info \
      | grep output_base \
      | awk '{print $NF}'
}

envoy::rm_symlink &>/dev/null