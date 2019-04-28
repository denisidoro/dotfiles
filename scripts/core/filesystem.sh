#!/usr/bin/env bash

fs::is_file() {
   local file=${1}
   [[ -f ${file} ]]
}

fs::is_dir() {
   local dir=${1}
   [[ -d ${dir} ]]
}
