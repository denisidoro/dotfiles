#!/usr/bin/env bash

platform::command_exists() {
   type "$1" &>/dev/null
}

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
   elif platform::command_exists apt; then
      echo "apt"
   elif platform::command_exists apt-get; then
      local -r apt_get_path="$(which apt-get)"
      local -r apt_path="$(echo "$apt_get_path" | sed 's/-get//')"
      sudo ln -s "$apt_get_path" "$apt_path"
      echo "apt"
   elif platform::command_exists yum; then
      echo "yum"
   elif platform::command_exists dnf; then
      echo "dnf"
   elif platform::command_exists apk; then
      echo "apk"
   else
      echo "brew"
   fi
}
