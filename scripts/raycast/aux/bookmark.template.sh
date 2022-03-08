#!/usr/bin/env bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ${title}
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📁
# @raycast.packageName Favorites

# Documentation:
# @raycast.description Open ${title} folder
# @raycast.author Denis Isidoro
# @raycast.authorURL https://denisidoro.github.io

open "${path}"
