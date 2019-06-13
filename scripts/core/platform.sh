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

platform::is_android() {
   [[ $(uname -a | grep -q "Android" || echo 1) -eq 0 ]]
}

platform::tags() {
   local tags=""
   if platform::is_osx; then tags="${tags}osx "; fi
   if platform::is_linux; then tags="${tags}linux "; fi
   if platform::is_arm; then tags="${tags}arm "; fi
   if platform::is_x86; then tags="${tags}x86 "; fi
   if platform::is_android; then tags="${tags}android "; fi
   if platform::is_wsl; then tags="${tags}wsl "; fi
   echo "$tags"
}

if ! platform::command_exists dot; then
   dot() { "$DOTFILES/bin/dot" "$@"; }
   export -f dot
fi
