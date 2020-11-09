#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES}/scripts/core/main.sh"

export DEV_HOME="${DEV_HOME:-${HOME}/dev}"
export KNOWLEDGE_HOME="${DEV_HOME}/knowledge"