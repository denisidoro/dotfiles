#!/usr/bin/env bash

function fs::is_file() {
   local file=${1}
   [[ -f ${file} ]]
}

function fs::is_dir() {
   local dir=${1}
   [[ -d ${dir} ]]
}
