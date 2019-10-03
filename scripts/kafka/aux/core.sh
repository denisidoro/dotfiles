source "${DOTFILES}/scripts/core/documentation.sh"

kafka::call() {
   local -r bin="$1"
   shift 2
   "$KAFKA_HOME/bin/$bin.sh" "$@"
}

kafka::invalid() {
   local -r file="$0"
   local -r cmds="$(cat "$file" | grep -Eo '"[a-zA-Z]*"' | awk -F'"' '{print $2}')"
   >&2 echo -e "Invalid argument!\n\nPossible values:"
   >&2 echo "$cmds"
   exit 1
}