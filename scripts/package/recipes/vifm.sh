#!/usr/bin/env bash
# vim: filetype=sh

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