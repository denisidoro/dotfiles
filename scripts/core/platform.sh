#!/usr/bin/env bash

function command_exists() {
  type "$1" &> /dev/null ;
}

function is_osx {
  [[ `uname -s` == "Darwin" ]]
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

