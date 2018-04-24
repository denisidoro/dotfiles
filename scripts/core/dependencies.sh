#!/usr/bin/env bash

function rsrc() {
  echo "$DOTFILES/scripts/$1"
}

function script_dir() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

function read_dependencies() {
  local file
  file=$(rsrc "db/dependencies.txt")
  echo "$(cat "$file")\n\n"
}

function from_dependencies() {
  # install compatible grep if necessary
  if is_osx; then
   if ! command_exists ggrep; then
     brew tap homebrew/dupes
     brew install homebrew/dupes/grep
   fi
  fi

  for key in "$@"
  do
    echo "$dependencies" | grep -Pzo "^$key:\n(.|\n)*?\n{2}" | tail -n +2 | sed '/^$/d'                
  done
}
