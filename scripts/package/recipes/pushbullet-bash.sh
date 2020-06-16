#!/usr/bin/env bash
set -euo pipefail

user="Red5d"
repo="pushbullet-bash"

package::is_installed() {
   recipe::has_submodule $repo "pushbullet"
}

package::install() {
   dot pkg add git

   recipe::clone_as_submodule $user $repo
}