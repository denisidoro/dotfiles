#!/usr/bin/env bash
# vim: filetype=sh

source "${DOTFILES}/scripts/core/main.sh"

TEMP_FOLDER="/tmp/dotfiles"
MODULES_FOLDER="${DOTFILES}/modules"

recipe::folder() {
   echo "$TEMP_FOLDER/${1}"
}

step::shallow_github_clone() {
   local readonly user="$1" 
   local readonly repo="$2"
   local readonly folder="$(recipe::folder "$repo")"
   mkdir -p "$folder" || true
   git clone "https://github.com/${user}/${repo}" --depth 1 "$folder" || true
}

step::make() {
   local readonly repo="$1"
   cd "$(recipe::folder "$repo")"
   make && sudo make install
}

step::abort_installed() {
   local readonly cmd="$1"
   log::warning "${cmd} already installed"
   exit 0
}

step::abort_if_installed() {
   local readonly cmd="$1"
   if platform::command_exists "$cmd"; then
      step::abort_installed "$cmd"
   fi
}

recipe::has_submodule() {
   local readonly module="$1"
   local readonly module_path="${MODULES_FOLDER}/${module}"
   fs::is_dir "$module_path"
}

recipe::clone_as_submodule() {
   local readonly user="$1"
   local readonly original_repo="$2"
   local readonly repo="${3:-$original_repo}"
   local readonly module_path="${MODULES_FOLDER}/${repo}"
   git clone "https://github.com/${user}/${repo}" --depth 1 "$module_path"
}