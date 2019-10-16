#!/usr/bin/env bash
# vim: filetype=sh

floki::depends_on() {
   coll::new npm
}

floki::map() {
   dict::new npm floki
}

