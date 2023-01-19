#!/usr/bin/env bash
source "${DOTFILES}/scripts/core/main.sh"
source "${DOTFILES}/scripts/termux/aux/universal.sh"

export HOME="${HOME:-$TERMUX_HOME}"
export DOTFILES="${DOTFILES:-"${HOME}/dotfiles"}"
# DOT_BIN="${DOTFILES}/bin/dot"
export PREFIX="/data/data/com.termux/files/usr"
export LD_LIBRARY_PATH="${PREFIX}/lib"
export LD_PRELOAD="${LD_LIBRARY_PATH}/libtermux-exec.so"
export PATH="${PATH:-}:${PREFIX}/bin"
export LANG="en_US.UTF-8"
export SHELL="${PREFIX}/bin/bash"
export TERM="dumb"

dot_termux() {
   local -r script="$1"
   shift || true
   bash "${DOTFILES}/scripts/termux/${script}" "$@"
}

dot_script() {
   local -r folder="$1"
   local -r script="$2"
   shift 2 || true
   bash "${DOTFILES}/scripts/${folder}/${script}" "$@"
}

# exec "$SHELL" -l
# termux-chroot || true
# 
# _script() {
#    local -r path="$1"
#    shift
#    bash "$path" "$@"
# }
# 
# _dot() {
#    "${DOTFILES}/bin/dot" "$@"
# }
# 
# _eval() {
#    eval "$*"
# }
# 
# _main() {
#    local -r cmd="${1:-}"
#    shift
#    case "$cmd" in
#       eval) _eval "$@" ;;
#       script) _script "$@" ;;
#       dot) _dot "$@" ;;
#       *) exit 2 ;;
#    esac
# }
# 
# _main "$@"
# 

run_bin() {
   local -r name="$1"
   local -r bin="$2"
   local -r use_config="$3"
   local -r meta_args=2

   local config=""
   if $use_config; then 
      config="${3//@/\"}"
      meta_args=3
   fi
   shift "$meta_args" || true

   local -r timestamp="$(date +"%Y-%m-%dT%H-%M-%S")"
   local log="${TASKER_TMP}/${name}_${timestamp}_log.txt"

   local i=0
   for arg in "$@"; do 
      echo "arg${i}: ${arg}"
      i=$((i+1))
   done

   for i in "$@"; do
      case "$i" in
         "%"*) 
           echo "aborting because of undefined input" > "$log"
           exit 1
           ;;
      esac
   done

   # local -r config_file="${TASKER_TMP}/${name}_${timestamp}_config.yaml"
   # rm "$config_file" || true
   # mkdir -p "$(dirname "$config_file")" || true 
   # echo "$config" > "$config_file"

   if [ -n "$config" ]; then
      "$bin" --config <(echo "$config") "$@" |& tee "$log"
   else
      "$bin" "$@" |& tee "$log"
   fi
}
