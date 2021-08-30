#!/usr/bin/env bash

dot_update() {
   source "$DOT_SCRIPT_ROOTDIR/pull.sh"
   source "$DOT_SCRIPT_ROOTDIR/set.sh"
   dot_pull
   dot_set $@

   unset -f "$0"
}
