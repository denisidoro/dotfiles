#!/usr/bin/env bash
# vim: filetype=sh

TEMP_FOLDER="${HOME}/tmp"
RECIPES_FILE="${DOTFILES}/scripts/pkg/aux/recipes.sh"
source "$RECIPES_FILE"

step::shallow_github_clone() {
   local readonly user="$1" 
   local readonly repo="$2"
   mkdir -p "$TEMP_FOLDER"
   git clone "https://github.com/${user}/${repo}" --depth 1 "${TEMP_FOLDER}/${repo}"
}

step::make() {
   local repo="$1"
   cd "${TEMP_FOLDER}/${repo}"
   make && sudo make install
}

batch::read() {
   local file
   file=$(rsrc "environment/aux/dependencies.txt")
   echo "$(cat "$file")\n\n"
}

batch::from() {
   for key in "$@"; do
     batch::read \
        | grep -Pzo "\[$key\]\s+(.|\n)*?($|\n{2})" \
        | tail -n +2 \
        | sed '/^$/d'
   done
}

recipe::list() {
  cat "${RECIPES_FILE}" \
    | grep recipe:: \
    | sed -E 's/recipe::(.*?)\(.*/\1/g'
}

recipe::install() {
   local readonly dep="$1"
   "recipe::${dep}"
}

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