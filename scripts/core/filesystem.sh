#!/usr/bin/env bash

fs::is_file() {
   local file=${1}
   [[ -f ${file} ]]
}

fs::is_dir() {
   local dir=${1}
   [[ -d ${dir} ]]
}

fs::realpath() {
   local readonly relative_path="$1"
   echo "$(cd "$(dirname "$relative_path")"; pwd)/$(basename "$relative_path")"
}

fs::tmp() {
   if platform::has_stubbed_sudo; then
      local folder="${DOTFILES}/local/tmp"
   else
      local folder="/tmp/dotfiles"
   fi
   mkdir "$folder" &> /dev/null || true
   echo "$folder"
}

fs::bin() {
   if platform::has_stubbed_sudo; then
      local folder="${DOTFILES}/local/bin"
   else
      local folder="/usr/local/bin"
   fi
   mkdir "$folder" &> /dev/null || true
   echo "$folder"
}