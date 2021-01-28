#!/usr/bin/env bash
set -euo pipefail

package::install() {
   has brew && brew cask install google-cloud-sdk && return 0 || true
   dot pkg add --prevent-recipe gcloud && return 0 || true
   curl https://sdk.cloud.google.com | bash
}
