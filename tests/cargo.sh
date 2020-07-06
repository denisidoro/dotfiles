#!/usr/bin/env bash

_cargo_test() {
   cd "${DOTFILES}/rust"
   cargo test
}

test::set_suite "rust - cargo"

if ${DOT_SKIP_CARGO:-false}; then
   fn=test::skip
else
   fn=test::run
fi

$fn "test" _cargo_test
