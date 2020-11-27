export DOTFILES="${DOTFILES:-${HOME}/dotfiles}"
export SDCARD_TASKER="${SDCARD_TASKER:-/sdcard/Tasker}"
export SDCARD_DOTFILES="${SDCARD_DOTFILES:-/sdcard/dotfiles}"

_script() {
   exit 3
}

_dot() {
   "${DOTFILES}/bin/dot" "$@"
}

_eval() {
   eval "$*"
}

_handler() {
   local -r cmd="${1:-}"
   shift
   case "$cmd" in
      eval) _eval "$@" ;;
      script) _script "$@" ;;
      dot) _dot "$@" ;;
      *) exit 2 ;;
   esac
}

_main() {
   args=($(eval "for arg in $*; do echo \$arg; done"))
   _handler "${args[@]:-}"
}

_main "$@"
