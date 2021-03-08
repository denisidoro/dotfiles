#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add rustup cargo
   curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
   cargo install cargo-generate
   rustup component add llvm-tools-preview --toolchain nightly
   rustup toolchain install nightly
}