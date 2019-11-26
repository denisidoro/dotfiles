export TASKER_HOME="${TASKER_HOME:-/sdcard/Tasker}"
source "${TASKER_HOME}/sh/core.sh"

## Wifi helpers
##
## Usage after sourcing:
##    group_name "%WIFII" "%text"
##    is_connected "%WIFII"
##
## Variables:
##    %WIFII  built-in Tasker variable
##    %text   network name <> ID mapping

network_name() {
   echo "$*" \
      | coll::get 2 \
      | str::lowercase
}

is_connected() {
   echo "$*" \
      | head -n1 \
      | grep -q CONNECT
}

group_for_network() {
   local -r text="$1"
   local -r network="$2"

   echo "$text" \
      | grep "$network" -B 90 \
      | tac \
      | grep '\[' \
      | head -n1 \
      | tr -d '[' \
      | tr -d ']'
}

group_name() {
   local -r info="$1"
   local -r text="$2"

   if is_connected "$info"; then
      local -r network="$(network_name "$info")"
      group_for_network "$text" "$(network_name "$text")"
   else
      echo 0
   fi
}
