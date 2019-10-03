#!/usr/bin/env bash
# vim: filetype=sh

RECIPES_FOLDER="${DOTFILES}/scripts/package/recipes"

recipe::list() {
   ls "${RECIPES_FOLDER}" \
      | sed 's/\.sh//g'
}

recipe::install() {
   local -r dep="$1"
   bash "${RECIPES_FOLDER}/${dep}.sh"
}

filter::with_recipe() {
   local -r deps="$1"
   local -r regex="$2"
   echo "$deps" | grep -E "$regex"
}

filter::without_recipe() {
   local -r deps="$1"
   local -r regex="$2"
   echo "$deps" | grep -Ev "$regex"
}

str::join() {
   tr '\n' ' ' | xargs
}

str::multiline() {
   tr ' ' '\n'
}

str::regex() {
   tr ' ' '|'
}
