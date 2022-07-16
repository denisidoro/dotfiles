#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/fs.sh"

TMP_DIR="$(platform::get_tmp_dir)"

recipe::folder() {
   echo "${TMP_DIR}/${1}"
}

git::url() {
   local -r user="$1"
   local -r repo="$2"
   local -r host="${DOT_GIT_HOST:-github.com}"

   local -r git_name="$(git config user.name || echo "")"
   local -r rsa_file="$HOME/.ssh/id_rsa"

   if has ssh && [[ -n "$git_name" ]] && [[ -f "$rsa_file" ]]; then
      echo "git@${host}:${user}/${repo}.git"
   else
      echo "https://${host}/${user}/${repo}"
   fi
}

recipe::shallow_git_clone() {
   local -r user="$1"
   local -r repo="$2"
   local -r folder="$(recipe::folder "$repo")"
   mkdir -p "$folder" || true
   sudo chmod 777 "$folder" || true
   yes | git clone "$(git::url "$user" "$repo")" --depth 1 "$folder" || true
}

recipe::shallow_github_clone() {
   export DOT_GIT_HOST="${DOT_GIT_HOST:-github.com}"
   recipe::shallow_git_clone "$@"
}

recipe::shallow_gitlab_clone() {
   export DOT_GIT_HOST="${DOT_GIT_HOST:-gitlab.com}"
   recipe::shallow_git_clone "$@"
}

recipe::check_if_can_build() {
   if ! ${DOT_PKG_ALLOW_BUILD:-true}; then
      log::error "Building binaries not allowed!"
      exit 1
   fi
}

recipe::make() {
   recipe::check_if_can_build
   local -r repo="$1"
   cd "$(recipe::folder "$repo")" || exit
   make && sudo make install
}

recipe::clone_as_submodule() {
   local -r user="$1"
   local -r repo="$2"
   local -r module="${3:-$repo}"

   local -r module_path="${MODULES_FOLDER}/${module}"
   yes | git clone "$(git::url "$user" "$repo")" --depth 1 "$module_path"

   cd "$module_path" || exit
   set +e
   git submodule init 2> /dev/null
   git submodule update 2> /dev/null
   set -e
}

recipe::install_from_git() {
   recipe::check_if_can_build
   
   local -r repo="$(echo "$@" | tr ' ' '/')"

   local -r package="$(basename "$repo")"
   local -r path="/opt/${package}"

   cd "/opt" || exit
   git clone "https://github.com/${repo}" --depth 1
   cd "$path" || exit

   if [ -f build.sh ]; then
      ./build.sh
   elif [ -f Makefile ]; then
      make install
   fi
}

recipe::cargo() {
   local -r cargo_name="$1"
   local -r pkg_manager_name="${2:-$cargo_name}"

   if dot pkg add --prevent-recipe "$pkg_manager_name"; then
      return 0
   else
      recipe::check_if_can_build
      dot pkg add cargo
      cargo install "$cargo_name"
   fi
}
