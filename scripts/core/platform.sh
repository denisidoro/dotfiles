#!/usr/bin/env bash

function command_exists() {
  type "$1" &> /dev/null ;
}

function is_osx {
  [[ $(uname -s) == "Darwin" ]]
}

function is_linux {
  [[ $(uname -s) == "Linux" ]]
}

function is_arm {  
  [[ $(uname -a | grep -q "armv" || echo 1) -eq 0 ]] 
}

function is_x86 {  
  [[ $(uname -a | grep -q "x86" || echo 1) -eq 0 ]] 
}

function is_android {  
  [[ $(uname -a | grep -q "Android" || echo 1) -eq 0 ]] 
}

function get_package_manager() {
  if command_exists brew; then echo "brew";
  elif command_exists apt; then echo "apt";
  else echo ""; fi
}

function platform_tags() {
  local tags="$(get_package_manager) "
  if is_osx; then tags="${tags}osx "; fi
  if is_linux; then tags="${tags}linux "; fi
  if is_arm; then tags="${tags}arm "; fi
  if is_x86; then tags="${tags}x86 "; fi
  if is_android; then tags="${tags}android "; fi
  echo "$tags"
}

if ! command_exists dot; then
  function dot() { "$DOTFILES/bin/dot" "$@"; }
  export -f dot
fi
