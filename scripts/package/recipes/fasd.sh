#!/usr/bin/env bash
# vim: filetype=sh

fasd::depends_on() {
   coll::new zlua
}

fasd::install() {
   log::warning "FASD has been deprecated! Installing z.lua instead..."
}
