#!/usr/bin/env bash
# vim: filetype=sh

user="dominictarr"
repo="JSON.sh"
module="json-sh"

json-sh::is_installed() {
   recipe::has_submodule $module "JSON.sh"
}

json-sh::install() {
   recipe::clone_as_submodule $user $repo $module
}
