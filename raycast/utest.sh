#!/usr/bin/env -i bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Emoji
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📙
# @raycast.packageName Emoji
# @raycast.argument1 { "type": "text", "placeholder": "Search for..." }

# Documentation:
# @raycast.description Copy emoji to clipboard
# @raycast.author Denis Isidoro
# @raycast.authorURL https://denisidoro.github.io

export HOME="/Users/denis.isidoro"
source "$HOME/.bashrc"
export SSH_AUTH_SOCK=/private/tmp/com.apple.launchd.EwdP84nKmW/Listeners
/opt/uber/bin/ussh