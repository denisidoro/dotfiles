#!/usr/bin/env bash
# vim: filetype=sh

user="jasperes"
repo="bash-yaml"

bash-yaml::is_installed() {
   recipe::has_submodule $repo "script/yaml.sh"
}

bash-yaml::install() {
   recipe::clone_as_submodule $user $repo
}