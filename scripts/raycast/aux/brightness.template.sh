#!/usr/bin/env bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ${level}
# @raycast.mode silent

# Optional parameters:
# @raycast.icon /Users/denis.isidoro/Pictures/Icons/navi_128.png
# @raycast.packageName Brightness

# Documentation:
# @raycast.description Brightness ${level}
# @raycast.author Denis Isidoro
# @raycast.authorURL https://denisidoro.github.io

"${HOME}/dotfiles/bin/dot" system display q 1 -b ${n} -c ${n} 
