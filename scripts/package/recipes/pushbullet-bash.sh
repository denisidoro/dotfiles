#!/usr/bin/env bash
# vim: filetype=sh

user="Red5d"
repo="pushbullet-bash"

pushbullet-bash::is_installed() {
   recipe::has_submodule $repo "pushbullet"
}

pushbullet-bash::install() {
   recipe::clone_as_submodule $user $repo
}