#!/usr/bin/env bash

dot_update() {
   source "$DOT_SCRIPT_ROOTDIR/aux/pull.sh"
   source "$DOT_SCRIPT_ROOTDIR/aux/set.sh"
   dot_pull
   dot_set $@

   unset -f "$0"
}
