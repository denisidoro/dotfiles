#!/usr/bin/env bash
# vim: filetype=sh

source "${DOTFILES}/scripts/core/main.sh"

TEMP_FOLDER="/tmp/dotfiles"
MODULES_FOLDER="${DOTFILES}/modules"

recipe::folder() {
   echo "$TEMP_FOLDER/${1}"
}

github::url() {
   local readonly user="$1" 
   local readonly repo="$2"

   if platform::command_exists ssh; then
      echo "git@github.com:${user}/${repo}.git"
   else
      echo "https://github.com/${user}/${repo}"
   fi
}

recipe::shallow_github_clone() {
   local readonly user="$1" 
   local readonly repo="$2"
   local readonly folder="$(recipe::folder "$repo")"
   mkdir -p "$folder" || true
   git clone "$(github::url $user $repo)" --depth 1 "$folder" || true
}

recipe::make() {
   local readonly repo="$1"
   cd "$(recipe::folder "$repo")"
   make && sudo make install
}

recipe::abort_installed() {
   local readonly cmd="$1"
   log::warning "${cmd} already installed"
   exit 0
}

recipe::abort_if_installed() {
   local readonly cmd="$1"
   if platform::command_exists "$cmd"; then
      recipe::abort_installed "$cmd"
   fi
}

recipe::has_submodule() {
   local readonly module="$1"
   local readonly probe_file="${2:-}"

   local readonly module_path="${MODULES_FOLDER}/${module}"

   if [[ -n $probe_file ]]; then
      local readonly probe_path="${module_path}/${probe_file}"
      fs::is_file "$probe_path"
   else
      fs::is_dir "$module_path"
   fi
}

recipe::clone_as_submodule() {
   local readonly user="$1"
   local readonly repo="$2"
   local readonly module="${3:-$repo}"

   local readonly module_path="${MODULES_FOLDER}/${module}"
   git clone "$(github::url $user $repo)" --depth 1 "$module_path"
}