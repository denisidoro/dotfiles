#!/usr/bin/env bash
set -euo pipefail

package::install() {
   local -r dir="$(mktemp -d)"
   cd "$dir"
   wget "https://github.com/raycast/extensions/raw/28d400f1c7f4bcb23e56e87ad472208df996e6ed/extensions/keyboard-layout-switcher/assets/keyboardSwitcher"
   sudo mv ./keyboardSwitcher /usr/local/bin/keyboardSwitcher
}
