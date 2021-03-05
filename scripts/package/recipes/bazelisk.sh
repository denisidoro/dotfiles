#!/usr/bin/env bash
set -euo pipefail

package::install() {
   dot pkg add volta
   volta install @bazel/bazelisk
}
