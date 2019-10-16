#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

clj::install() {
  dot pkg install clojure 
}
