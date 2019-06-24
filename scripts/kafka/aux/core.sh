kafka::call() {
   local readonly bin="$1"
   shift 2
   "$KAFKA_HOME/bin/$bin.sh" "$@"
}

kafka::invalid() {
   local readonly file="$0"
   local readonly cmds="$(cat "$file" | grep -Eo '"[a-zA-Z]*"' | awk -F'"' '{print $2}')"
   >&2 echo -e "Invalid argument!\n\nPossible values:"
   >&2 echo "$cmds"
   exit 1
}