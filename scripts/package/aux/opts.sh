#!/usr/bin/env bash
set -euo pipefail

opts::eval() {
   local wait_for=""
   local entry_point="install"
   local ask=false
   local print=false
   local values=""
   local path="${RECIPE_PATH:-${RECIPE_DIR:-${SCRIPT_HOME}/recipes}}"
   local pkg_managers="$(pkg_manager::relevant)"

   case "${1:-}" in
      --version|version) entry_point="version"; shift ;;
      --full-version|full-version) entry_point="full-version"; shift ;;
      --help|help) entry_point="help"; shift ;;
      home) entry_point="home"; shift ;;
      script) entry_point="script"; shift; SCRIPT_ARGS="$@" ;;
      install) entry_point="install"; shift ;;
      remove) entry_point="remove"; shift ;;
      update) entry_point="update"; shift ;;
      upgrade) entry_point="upgrade"; shift ;;
      info) entry_point="info"; shift ;;
      search) entry_point="search"; shift ;;
      list) entry_point="list"; shift ;;
   esac

   for arg in "$@"; do
      case $wait_for in
         path) path="$arg"; wait_for=""; continue ;;
      esac

      case $arg in
         --print) print=true ;;
         --no-custom) pkg_managers="$(echo "$pkg_managers" | sed 's/custom//g')" ;;
         --ask|--a) ask="true" ;;
         --path|--dir) wait_for="path" ;;
         *) values="$(echo "$values" | coll::add "$arg")" ;;
      esac
   done

   OPTIONS="$(dict::new \
      entry_point "$entry_point" \
      print "$print" \
      ask "$ask" \
      values "$values" \
      pkg_managers "$pkg_managers")"

   export RECIPE_PATH="$path"
}
