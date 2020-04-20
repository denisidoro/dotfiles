#!/usr/bin/env bash
# vim: filetype=sh

user="Red5d"
repo="pushbullet-bash"

package::is_installed() {
   recipe::has_submodule $repo "pushbullet"
}

package::install() {
   recipe::clone_as_submodule $user $repo
}