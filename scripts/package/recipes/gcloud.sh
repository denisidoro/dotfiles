#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if has brew; then
      brew cask install google-cloud-sdk && return 0 || return 1
   fi
   dot pkg add gcloud --prevent-recipe || dot pkg add google-cloud-sdk --prevent-recipe
}
