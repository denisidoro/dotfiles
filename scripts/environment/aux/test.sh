#!/usr/bin/env bash
# vim: filetype=sh

source "${DOTFILES}/scripts/core/main.sh"

test::fail() {
   log::error "FAILED..."
   exit 1
}

test::success() {
   log::success "PASSED!"
}

test::fact() {
   log::warning "Test case: $@"
}
