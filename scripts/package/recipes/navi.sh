#!/usr/bin/env bash
# vim: filetype=sh

package::install() {
   package::command_exists brew && brew install navi && return 0 || true

   bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
}
