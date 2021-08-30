#!/usr/bin/env bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ${title}
# @raycast.mode silent

# Optional parameters:
# @raycast.icon /Users/denis.isidoro/Pictures/Icons/${icon}_64.png
# @raycast.packageName Browser

# Documentation:
# @raycast.description Focus on ${title} tab
# @raycast.author Denis Isidoro
# @raycast.authorURL https://denisidoro.github.io

"${HOME}/dotfiles/bin/dot" osx focus-tab "${query}" "${url}"
