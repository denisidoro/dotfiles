#!/usr/bin/env bash
# vim: filetype=sh

package::install() {
   package::command_exists brew && brew install denisidoro/tools/navi && return 0

   bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
}