#!/usr/bin/env bash
# vim: filetype=sh

package::install() {
   recipe::install_from_git skywind3000 z.lua
}
