#!/usr/bin/env bash
# vim: filetype=sh

lua::install() {
   dot pkg add --no-custom lua && exit 0 || true

   main_package_manager="$(platform::main_package_manager)"

   if [[ $main_package_manager = "apt" ]]; then
      VERSION=${VERSION:-5.3}
      luacmd="lua${VERSION}"
      dot pkg add --no-custom "$luacmd"
      sudo mv "$luacmd" "$(fs::bin)/lua"
      exit 0
   fi
}
