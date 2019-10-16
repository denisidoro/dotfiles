#!/usr/bin/env bash

package::load_custom_recipe() {
   local -r package="$1"

   for path in $(echo "$RECIPE_PATH" | tr ':' '\n'); do
      source "${path}/${package}.sh" 2>/dev/null || true
   done
}

package::fn() {
   local -r package="$1"
   local -r operation="$2"

   echo "${package}::${operation}"
}
