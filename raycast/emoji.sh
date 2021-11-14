#!/usr/bin/env bash --norc --noprofile

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

export PATH="${PATH}:${HOME}/.volta/bin"
export LANG=en_US.UTF-8

if ! command -v emoj &> /dev/null; then
	echo "emoj command not available"
	echo "run volta install emoj"
	exit 1
fi

main() {
   local query="$*"
   query="${query// /_}"
   query="${query//-/_}"

   case "$query" in
      done|check|checkmark|mark) query="white_ch" ;;
   esac

   local -r emojis="$(emoj "$query")"

   if [ -z "$emojis" ]; then
      echo "No emojis found for \"${query}\""
      exit 1
   fi

   local -r emoji="$(echo "$emojis" | cut -d' ' -f1)"
   printf "%s" "$emoji" | pbcopy
   echo "Copied ${emoji} to clipboard"
}

main "$@"
