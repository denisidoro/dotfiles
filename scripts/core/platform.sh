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
  [[ $(uname -s | grep -q "armv" || echo 1) -eq 0 ]] 
}

function get_package_manager() {
  case "$(uname -s)" in
    Darwin)
      echo brew
      ;;
    *)
      if command_exists apt
      then
  echo apt
      fi
      ;;
  esac
}

if ! command_exists dot; then
  function dot() { "$DOTFILES/bin/dot" "$@"; }
  export -f dot
fi
