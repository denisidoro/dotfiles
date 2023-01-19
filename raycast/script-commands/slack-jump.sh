#!/usr/bin/env bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Jump to...
# @raycast.mode silent

# Optional parameters:
# @raycast.icon images/slack-logo.png
# @raycast.packageName Slack
# @raycast.argument1 { "type": "text", "placeholder": "Channel / DM / File / Misc" }

# Documentation:
# @raycast.author Jakub Lanski
# @raycast.authorURL https://github.com/jaklan

main() {
local query="$1"

bash "${HOME}/dotfiles/raycast/slack.sh"

local code
set +e
read -r -d '' code <<EOF
set inputDelay to 0.5
set enterDelay to 0.5

tell application "System Events"
   keystroke "k" using command down
   delay inputDelay
   keystroke "$query"
   delay enterDelay
   key code 36
end tell
EOF
   set -e

   osascript -e "$code"
}

main "$@"