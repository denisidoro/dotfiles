#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/main.sh"

export PROJ_HOME="${PROJ_HOME:-$PWD}"
export PROJ_NAME="${PROJ_NAME:-$(basename "$PROJ_HOME")}"


# =====================
# paths
# =====================

get_dir() {
   local -r first_dir="$1"
   local -r second_dir="$2"
   local -r useless_folder="${first_dir}/useless"
   local folder
   mkdir -p "$useless_folder" 2>/dev/null \
      && folder="$first_dir" \
      || folder="$second_dir"
   rm -r "$useless_folder" 2>/dev/null
   echo "$folder"
}

get_source_dir() {
   get_dir "/opt/${PROJ_NAME}" "${HOME}/.${PROJ_NAME}/src"
}

get_bin_dir() {
   get_dir "/usr/bin" "/usr/local/bin"
}

get_tmp_dir() {
   get_dir "/tmp/${PROJ_NAME}" "${HOME}/.${PROJ_NAME}/tmp"
}


# =====================
# logging
# =====================

echoerr() {
   echo "$@" 1>&2
}

tap() {
   local -r x="$(cat)"
   echoerr "$x"
   echo "$x"
}

log::ansi() {
   local bg=false
   case "$@" in
      *reset*) echo "\e[0m"; return 0 ;;
      *black*) color=30 ;;
      *red*) color=31 ;;
      *green*) color=32 ;;
      *yellow*) color=33 ;;
      *blue*) color=34 ;;
      *purple*) color=35 ;;
      *cyan*) color=36 ;;
      *white*) color=37 ;;
   esac
   case "$@" in
      *regular*) mod=0 ;;
      *bold*) mod=1 ;;
      *underline*) mod=4 ;;
   esac
   case "$@" in
      *background*) bg=true ;;
      *bg*) bg=true ;;
   esac

   if $bg; then
      echo "\e[${color}m"
   else
      echo "\e[${mod:-0};${color}m"
   fi
}

_log() {
   local template="$1"
   shift
   echoerr -e "$(printf "$template" "$@")"
}

_header() {
   local TOTAL_CHARS=60
   local total=$TOTAL_CHARS-2
   local size=${#1}
   local left=$((($total - $size) / 2))
   local right=$(($total - $size - $left))
   printf "%${left}s" '' | tr ' ' =
   printf " $1 "
   printf "%${right}s" '' | tr ' ' =
}

log::header() { _log "\n$(log::ansi bold)$(log::ansi purple)$(_header "$1")$(log::ansi reset)\n"; }
log::success() { _log "$(log::ansi green)✔ %s$(log::ansi reset)\n" "$@"; }
log::error() { _log "$(log::ansi red)✖ %s$(log::ansi reset)\n" "$@"; }
log::warning() { _log "$(log::ansi yellow)➜ %s$(log::ansi reset)\n" "$@"; }
log::note() { _log "$(log::ansi blue)%s$(log::ansi reset)\n" "$@"; }

# TODO: remove
header() {
   echoerr "$*"
   echoerr
}

die() {
   log::error "$@"
   exit 42
}

no_binary_warning() {
   echoerr "There's no precompiled binary for your platform: $(uname -a)"
}

installation_finish_instructions() {
   echoerr -e "Finished. To call ${PROJ_NAME}, restart your shell or reload the config file:\n   source ~/.${shell}rc"
}


# =====================
# security
# =====================

sha256() {
   if command_exists sha256sum; then
      sha256sum
   elif command_exists shasum; then
      shasum -a 256
   elif command_exists openssl; then
      openssl dgst -sha256
   else
      echoerr "Unable to calculate sha256!"
      exit 43
   fi
}


# =====================
# github
# =====================

latest_version_released() {
   curl -s "https://api.github.com/repos/denisidoro/${PROJ_NAME}/releases/latest" \
      | grep -Eo 'releases/tag/v([0-9\.]+)' \
      | sed 's|releases/tag/v||'
}

asset_url() {
   local -r version="$1"
   local -r variant="${2:-}"

   if [[ -n "$variant" ]]; then
      echo "https://github.com/denisidoro/${PROJ_NAME}/releases/download/v${version}/${PROJ_NAME}-v${version}-${variant}.tar.gz"
   else
      echo "https://github.com/denisidoro/${PROJ_NAME}/archive/v${version}.tar.gz"
   fi
}

download_asset() {
   local -r url="$(asset_url "$@")"
   local -r gz_path="${PROJ_NAME}.tar.gz"
   mkdir -p "$TMP_DIR"
   cd "$TMP_DIR"
   rm -f "$gz_path"
   echoerr "Downloading ${url}..."
   curl -L "$url" -o "$gz_path"
   tar xvzf "$gz_path"
   rm -f "$gz_path"
   cp "${TMP_DIR}/${PROJ_NAME}" "${BIN_DIR}/${PROJ_NAME}"
}

sha_for_asset_on_github() {
   local -r url="$(asset_url "$@")"
   curl -sL "$url" | sha256 | awk '{print $1}'
}


# =====================
# code
# =====================

version_from_toml() {
   cat "${PROJ_HOME}/Cargo.toml" \
      | grep version \
      | head -n1 \
      | awk '{print $NF}' \
      | tr -d '"' \
      | tr -d "'"
}


# =====================
# platform
# =====================

command_exists() {
   type "$1" &>/dev/null
}

get_target() {
   local -r unamea="$(uname -a)"
   local -r archi="$(uname -sm)"
   local is_android

   [[ $unamea = *Android* ]] && is_android=true || is_android=false

   local target
   case "$archi" in
      Darwin*) target="x86_64-osx" ;;
      *x86*) $is_android && target="" || target="x86_64-unknown-linux-musl" ;;
      *aarch*) $is_android && target="aarch64-linux-android" || target="armv7-unknown-linux-musleabihf" ;;
      *arm*) $is_android && target="armv7-linux-androideabi" || target="armv7-unknown-linux-musleabihf" ;;
      *) target="" ;;
   esac

   echo "$target"
}

get_shell() {
   echo $SHELL | xargs basename
}


# =====================
# main
# =====================

install_proj() {
   export SRC_DIR="${SRC_DIR:-"$(get_source_dir)"}"
   export BIN_DIR="${BIN_DIR:-"$(get_bin_dir)"}"
   export TMP_DIR="${TMP_DIR:-"$(get_tmp_dir)"}"
   echoerr -e "Relevant directories:\n- src: ${SRC_DIR}\n- bin: ${BIN_DIR}\n- tmp: ${TMP_DIR}\n"

   local -r target="$(get_target)"

   if [[ -n "$target" ]]; then
      local -r version="$(latest_version_released)"
      download_asset "$version" "$target"

   elif command_exists cargo; then
      no_binary_warning
      echoerr "Building sources..."
      git clone https://github.com/denisidoro/ "$SRC_DIR"
      cd "$SRC_DIR"
      make install

   else
      no_binary_warning
      echoerr "You don't have the necessary tools to build it"
      echoerr "Please open an issue at https://github.com/denisidoro/${PROJ_NAME}"
      echoerr "Aborting..."
      exit 33
   fi

   return 0
}
