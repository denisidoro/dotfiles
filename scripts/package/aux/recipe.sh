#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/fs.sh"
source "${DOTFILES}/scripts/package/aux/github_release.sh"

_git::url() {
   local -r user="$1"
   local -r repo="$2"
   local -r host="${DOT_GIT_HOST:-github.com}"

   local -r git_name="$(git config user.name || echo "")"
   local -r rsa_file="${HOME}/.ssh/id_rsa"

   if has ssh && [[ -n "$git_name" ]] && [[ -f "$rsa_file" ]]; then
      echo "git@${host}:${user}/${repo}.git"
   else
      echo "https://${host}/${user}/${repo}"
   fi
}

_recipe::shallow_git_clone() {
   local -r user="$1"
   local -r repo="$2"

   local -r folder="$(platform::get_tmp_dir)"
   mkdir -p "$folder" || true
   sudo chmod 777 "$folder" || true

   dot pkg add git &> /dev/null
   yes | git clone "$(_git::url "$user" "$repo")" --depth 1 "$folder" >&2

   echo "$folder"
}

recipe::shallow_github_clone() {
   export DOT_GIT_HOST="${DOT_GIT_HOST:-github.com}"
   _recipe::shallow_git_clone "$@"
}

recipe::shallow_gitlab_clone() {
   export DOT_GIT_HOST="${DOT_GIT_HOST:-gitlab.com}"
   _recipe::shallow_git_clone "$@"
}

recipe::check_if_can_build() {
   if ! ${DOT_PKG_ALLOW_BUILD:-true}; then
      log::error "Building binaries not allowed!"
      exit 1
   fi
}

recipe::install() {
   recipe::check_if_can_build

   if [ -f build.sh ]; then
      ./build.sh
   elif [ -f Makefile ]; then
      yes | make
      yes | sudo make install || true
   fi
}

recipe::cargo() {
   recipe::check_if_can_build
   dot pkg add cargo &> /dev/null
   cargo install "$@"
}

recipe::install_github_release() {
   local -r repo="$1"
   local -r proj="$2"

   # shellcheck disable=SC2178
   local -r releases="$(release::get_all "$repo" "$proj")"
   # shellcheck disable=SC2128
   local -r url="$(release::best_match "$releases")"
   local -r file="$(_recipe::download_file "$url")"
   _recipe::install_file "$file"
}

_recipe::download_file() {
   local -r url="$1"
   local -r folder="$(mktemp -d)"

   cd "$folder" || exit
   dot pkg add wget &> /dev/null
   wget "$url" >&2

   find "$(pwd -P)" -type f | head -n1
}

_recipe::install_file() {
   local -r file="$1"

   case "$file" in
      *.tar.gz) _recipe::install_targz "$file" ;;
      *) die "Doesn't know how to install ${file}" ;;
   esac
}

_recipe::install_targz() {
   local -r file="$1"

   local -r extracted_folder="$(dirname "$file")/extracted"
   mkdir -p "$extracted_folder"
   tar -xvf "$file" --directory "$extracted_folder" >&2

   cd "$extracted_folder" || exit
   local -r extracted_file="$(find "$(pwd -P)" -type f | head -n1)"
   chmod +x "$extracted_file" || true
   
   local -r bin_dir="$(platform::get_bin_dir)"
   mv "$extracted_file" "$bin_dir" || sudo mv "$extracted_file" "$bin_dir"
}
