#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if ! [ -d "/data/data/com.termux" ]; then
      dot pkg add --ignore-recipe ncat
      return 0
   fi

   local -r from="/data/data/com.termux/files/usr/bin/ncat"
   local -r to="${HOME}/ncat"

   apt install -y nmap
   cp "$from" "$to"

   apt remove -y nmap
   mv "$to" "$from"
}
