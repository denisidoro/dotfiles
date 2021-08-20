#!/usr/bin/env -i bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title navi
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💬
# @raycast.packageName Browser

# Documentation:
# @raycast.description Focus on Slack tab
# @raycast.author Denis Isidoro
# @raycast.authorURL https://denisidoro.github.io

# shellcheck disable=SC1007
export DOTFILES="${DOTFILES:-"$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"}"
# source "${DOTFILES}/shell/aux/vars.bash"
export FZF_DEFAULT_OPTS='--tiebreak=begin --literal --layout=reverse --height 100% --inline-info --cycle'
export PATH="${PATH}:/usr/local/bin"

args=("navi")
if [ $# -eq 0 ]; then
   :
else
   args+=("--query")
   args+=("$* ")
fi

# env
/Applications/Alacritty.app/Contents/MacOS/alacritty --command "${args[@]}"
