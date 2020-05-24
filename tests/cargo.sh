#!/usr/bin/env bash

_cargo_test() {
    cd "${DOTFILES}/rust"
    cargo test
}

test::set_suite "rust - cargo"
test::run "test" _cargo_test
