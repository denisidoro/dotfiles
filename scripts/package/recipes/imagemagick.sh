#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   convert --version | grep -q "ImageMagick"
}

package::install() {
   dot pkg add --prevent-recipe imagemagick
}
