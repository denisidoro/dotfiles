#!/usr/bin/env bash
set -euo pipefail

package::install() {
   recipe::install_github_release denisidoro fre
}