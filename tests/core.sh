source "${DOTFILES}/scripts/core/main.sh"

test::fail() {
  log::error "FAILED..."
  exit 1
}

test::success() {
  log::success "PASSED!"
}
