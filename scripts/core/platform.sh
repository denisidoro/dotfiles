#!/usr/bin/env bash

function platform::command_exists() {
   type "$1" &>/dev/null
}

function platform::is_osx() {
   [[ $(uname -s) == "Darwin" ]]
}

function platform::is_linux() {
   [[ $(uname -s) == "Linux" ]]
}

function platform::is_bash_for_win() {
   grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null
}

function platform::is_arm() {
   [[ $(uname -a | grep -q "armv" || echo 1) -eq 0 ]]
}

function platform::is_x86() {
   [[ $(uname -a | grep -q "x86" || echo 1) -eq 0 ]]
}

function platform::is_android() {
   [[ $(uname -a | grep -q "Android" || echo 1) -eq 0 ]]
}

function platform::package_manager() {
   if platform::command_exists brew; then
      echo "brew"
   elif platform::command_exists apt; then
      echo "apt"
   else echo ""; fi
}

function platform::tags() {
   local tags="$(platform::package_manager) "
   if platform::is_osx; then tags="${tags}osx "; fi
   if platform::is_linux; then tags="${tags}linux "; fi
   if platform::is_arm; then tags="${tags}arm "; fi
   if platform::is_x86; then tags="${tags}x86 "; fi
   if platform::is_android; then tags="${tags}android "; fi
   echo "$tags"
}

if ! platform::command_exists dot; then
   function dot() { "$DOTFILES/bin/dot" "$@"; }
   export -f dot
fi
