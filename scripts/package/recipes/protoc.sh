#!/usr/bin/env bash
set -euo pipefail

package::install() {
   has brew && brew install protobuf && return 0 || true

   local -r PROTOC_ZIP=protoc-3.14.0-osx-x86_64.zip
   curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/$PROTOC_ZIP
   sudo unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
   sudo unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
   rm -f $PROTOC_ZIP
   sudo chmod +x /usr/local/bin/protoc
}
