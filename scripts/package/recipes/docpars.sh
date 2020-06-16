#!/usr/bin/env bash
 
package::install() {
   package::command_exists brew && brew install denisidoro/tools/docpars && return 0 || true

   bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
}
