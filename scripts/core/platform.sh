#!/usr/bin/env bash

function program_is_installed {
  local return_=1
  type $1 >/dev/null 2>&1 || { local return_=0; }
  echo "$return_"
}

function command_exists() {
  type "$1" &> /dev/null ;
}

function is_osx {
  [[ `uname -s` == "Darwin" ]]
}

function get_platform() {
  case "$(uname -s)" in
    Darwin)
      echo osx
      ;;
    *)
      if command_exists apt
      then
  echo apt
      fi
      ;;
  esac
}

