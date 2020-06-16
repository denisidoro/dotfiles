#!/usr/bin/env bash
 
package::install() {
   platform::command_exists brew && brew install leiningen && return 0

   dot pkg add wget

   folder="$(recipe::folder lein)"
   mkdir -p "$folder" || true
   cd "$folder"

   url="https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein"
   wget "$url" -O lein
   chmod a+x lein
   sudo mv lein "$(fs::bin)/lein"
}