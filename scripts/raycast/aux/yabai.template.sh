#!/usr/bin/env bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ${title}
# @raycast.mode silent

# Optional parameters:
# @raycast.icon /Users/denis.isidoro/Pictures/Icons/yabai_64.png
# @raycast.packageName Yabai

# Documentation:
# @raycast.description ${title}
# @raycast.author Denis Isidoro
# @raycast.authorURL https://denisidoro.github.io

yabai() {
   /usr/local/bin/yabai "$@"
}

${command}
