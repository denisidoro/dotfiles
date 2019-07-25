#!/usr/bin/env bash
# vim: filetype=sh

source "${DOTFILES}/scripts/core/main.sh"

TMP_DIR="$(fs::tmp)"
MODULES_FOLDER="${DOTFILES}/modules"

recipe::folder() {
   echo "${TMP_DIR}/${1}"
}

git::url() {
   local readonly user="$1"
   local readonly repo="$2"
   local readonly host="${DOT_GIT_HOST:-github.com}"

   local readonly git_name="$(git config user.name || echo "")"
   local readonly rsa_file="$HOME/.ssh/id_rsa"

   if platform::command_exists ssh && [[ -n "$git_name" ]] && [[ -f "$rsa_file" ]]; then
      echo "git@${host}:${user}/${repo}.git"
   else
      echo "https://${host}/${user}/${repo}"
   fi
}

recipe::shallow_git_clone() {
   local readonly user="$1"
   local readonly repo="$2"
   local readonly folder="$(recipe::folder "$repo")"
   mkdir -p "$folder" || true
   git clone "$(git::url $user $repo)" --depth 1 "$folder" || true
}

recipe::shallow_github_clone() {
   export DOT_GIT_HOST="${DOT_GIT_HOST:-github.com}"
   recipe::shallow_git_clone "$@"
}

recipe::shallow_gitlab_clone() {
   export DOT_GIT_HOST="${DOT_GIT_HOST:-gitlab.com}"
   recipe::shallow_git_clone "$@"
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
   git::url $user $repo
   git clone "$(git::url $user $repo)" --depth 1 "$module_path"
}