#!/usr/bin/env bash
# vim: filetype=sh

RECIPES_FOLDER="${DOTFILES}/scripts/package/recipes"

platform::main_package_manager() {
   if platform::is_osx; then
      echo "brew"
   elif platform::command_exists apt; then
      echo "apt"
   elif platform::command_exists yum; then
      echo "yum"
   elif platform::command_exists dnf; then
      echo "dnf"
   elif platform::command_exists apk; then
      echo "apk"
   elif platform::is_android; then
      echo "pkg"
   else 
      echo "brew"
   fi
}

recipe::list() {
  ls "${RECIPES_FOLDER}" \
    | sed 's/.sh//g'
}

recipe::install() {
   local readonly dep="$1"
   bash "${RECIPES_FOLDER}/${dep}.sh"
}

filter::with_recipe() {
   local readonly deps="$1"
   local readonly regex="$2"
   echo "$deps" | grep -E "$regex"
}

filter::without_recipe() {
   local readonly deps="$1"
   local readonly regex="$2"
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
