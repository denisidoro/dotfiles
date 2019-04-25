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
  if ! fs::is_file "${DOTFILES}/modules/json-sh/JSON.sh"; then
    git submodule update --init modules/json-sh
    git submodule update --init modules/bash-yaml
  fi
}
