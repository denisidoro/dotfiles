#!/usr/bin/env bash
 
package::install() {
   package::command_exists brew && brew install borkdude/brew/jet && return 0 || true

   bash <(curl -s https://raw.githubusercontent.com/borkdude/jet/master/install)
}