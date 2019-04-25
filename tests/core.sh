source "${DOTFILES}/scripts/core/main.sh"
export DOT_PATH="${DOTFILES}/bin/dot"

test::fail() {
  log::error "FAILED..."
  exit 1
}

test::success() {
  log::success "PASSED!"
}

dot::call() {
  if platform::command_exists dot; then
    dot "$@"  
  else
    "$DOT_PATH" -d "$@"
  fi
}

submodule::clone() {
  if ! fs::is_dir "${DOTFILES}/modules/json-sh"; then
    git submodule sync --recursive
    git submodule update --recursive --init
  fi
}