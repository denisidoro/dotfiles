#!/usr/bin/env bash
# vim: filetype=sh

terminalizer::depends_on() {
   coll::new npm
}

terminalizer::map() {
   dict::new npm floki
}
