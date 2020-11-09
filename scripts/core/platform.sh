#!/usr/bin/env bash

platform::is_osx() {
   [[ $(uname -s) == "Darwin" ]]
}

platform::is_linux() {
   [[ $(uname -s) == "Linux" ]]
}

platform::is_wsl() {
   grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null
}

platform::is_arm() {
   [[ $(uname -a | grep -q "armv" || echo 1) -eq 0 ]]
}

platform::is_x86() {
   [[ $(uname -a | grep -q "x86" || echo 1) -eq 0 ]]
}

platform::is_64bits() {
   [[ $(uname -a | grep -q "x86_64" || echo 1) -eq 0 ]]
}

platform::is_android() {
   [[ $(uname -a | grep -q "Android" || echo 1) -eq 0 ]]
}

platform::is_ami2() {
   local -r txt="$(uname -a)"
   [[ $(echo "$txt" | grep -q "Amazon Linux release 2" || echo "$txt" | grep -q "amzn2" || echo 1) -eq 0 ]]
}

platform::has_stubbed_sudo() {
   sudo --help 2> /dev/null \
      | grep -q "stub"
}

platform::tags() {
   local tags=""
   if platform::is_osx; then tags="${tags}osx "; fi
   if platform::is_linux; then tags="${tags}linux "; fi
   if platform::is_arm; then tags="${tags}arm "; fi
   if platform::is_x86; then tags="${tags}x86 "; fi
   if platform::is_64bits; then tags="${tags}64bits "; fi
   if platform::is_android; then tags="${tags}android "; fi
   if platform::is_wsl; then tags="${tags}wsl "; fi
   echo "$tags"
}

platform::main_package_manager() {
   if platform::is_osx; then
      echo "brew"
   elif platform::is_android; then
      echo "pkg"
   elif has apt; then
      echo "apt"
   elif has apt-get; then
      local -r apt_get_path="$(which apt-get)"
      local -r apt_path="$(echo "$apt_get_path" | sed 's/-get//')"
      sudo ln -s "$apt_get_path" "$apt_path"
      echo "apt"
   elif has yum; then
      echo "yum"
   elif has dnf; then
      echo "dnf"
   elif has apk; then
      echo "apk"
   else
      echo "brew"
   fi
}

platform::existing_command() {
   local cmd
   for cmd in "$@"; do
      if has "$cmd"; then
         echo "$cmd"
         return 0
      fi
   done
   return 1
}

# =====================
# paths
# =====================

platform::get_dir() {
   local -r dir="$1"

   if [[ $# -lt 2 ]]; then
      echo "$dir"
      return 0
   fi

   local -r useless_folder="${dir}/useless"
   mkdir -p "$useless_folder" 2>/dev/null \
      && rm -r "$useless_folder" 2>/dev/null \
      && echo "$dir" \
      && return 0

   shift
   platform::get_dir "$@"
}

platform::root() {
   if [ -n "${PREFIX:-}" ]; then
      local dir="$(cd "${PREFIX}/.." && pwd)"
      echo "$dir"
   fi
}

platform::get_source_dir() {
   local -r proj_name="${1:-}"
   platform::get_dir "$(platform::root)/opt/${proj_name}" "${HOME}/.${proj_name}/src"
}

platform::get_bin_dir() {
   platform::get_dir "$(platform::root)/usr/bin" "$(platform::root)/usr/local/bin" "${DOTFILES}/local/bin"
}

platform::get_tmp_dir() {
   local -r proj_name="${1:-}"
   platform::get_dir "$(platform::root)/tmp/${proj_name}" "${HOME}/.${proj_name}/tmp"
}

platform::rust_compatible_variant() {
   local -r unamea="$(uname -a)"
   local -r archi="$(uname -sm)"
   local is_android

   [[ $unamea = *Android* ]] && is_android=true || is_android=false

   local target
   case "$archi" in
      Darwin*) target="x86_64-osx" ;;
      *x86*) $is_android && target="" || target="x86_64-unknown-linux-musl" ;;
      *aarch*) $is_android && target="aarch64-linux-android" || target="armv7-unknown-linux-musleabihf" ;;
      *arm*) $is_android && target="armv7-linux-androideabi" || target="armv7-unknown-linux-musleabihf" ;;
      *) target="" ;;
   esac

   echo "$target"
}

platform::shell() {
   echo "$SHELL" | xargs basename
}
