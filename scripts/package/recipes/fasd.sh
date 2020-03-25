#!/usr/bin/env bash
# vim: filetype=sh

package::install() {
   log::warning "FASD has been deprecated! Installing z.lua instead..."
   dot pkg add zlua
}
