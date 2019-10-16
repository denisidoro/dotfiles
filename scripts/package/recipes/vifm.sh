#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

recipe::abort_if_installed vifm

vifm::depends_on() {
  coll::new libncurses5-dev libncursesw5-dev
}

vifm::install() {
  recipe::shallow_github_clone vifm vifm
  cd "$TMP_DIR/vifm"
  ./scripts/fix-timestamps || true
  ./configure
  recipe::make "vifm"
}