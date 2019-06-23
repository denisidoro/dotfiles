#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed heptio-authenticator-aws

dot pkg add aws-iam-authenticator
sudo ln -s "$(which aws-iam-authenticator)" /usr/bin/heptio-authenticator-aws
