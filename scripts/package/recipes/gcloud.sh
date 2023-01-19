#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if has brew && brew cask install google-cloud-sdk; then return 0; fi
   if dot pkg add --ignore-recipe gcloud; then return 0; fi
   curl https://sdk.cloud.google.com | bash
}
