#!/usr/bin/env bash
set -euo pipefail

package::install() {
   if has brew && brew install protobuf; then return 0; fi
   if has apt && sudo apt install -y protobuf-compiler protobuf-compiler; then return 0; fi

   local -r PROTOC_ZIP=protoc-3.14.0-osx-x86_64.zip
   curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/$PROTOC_ZIP
   sudo unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
   sudo unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
   rm -f $PROTOC_ZIP
   sudo chmod +x /usr/local/bin/protoc
}
