#!/usr/bin/env bash
set -euo pipefail

package::install() {
   # TODO
   local -r folder="$(platform::get_tmp_dir)"
   mkdir -p "$folder" || true
   sudo chmod 777 "$folder" || true

   cd "$folder"
   local -r filename="channeltcp-v0.2.2-armv7-linux-androideabi.tar.gz"
   rclone copy "box:/Downloads/Android/Mine/${filename}" .
   _recipe::install_file "$filename"
}
