#!/usr/bin/env bash
# vim: filetype=sh

package::install() {
   cd "$TMP_DIR"
   git clone https://github.com/bemeurer/beautysh
   cd beautysh
   if platform::command_exists python3; then
      python3 setup.py install
   else
      python setup.py install
   fi
}
