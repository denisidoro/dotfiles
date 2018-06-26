command: """
  chunkc=/usr/local/bin/chunkc
  monitor_id="$($chunkc tiling::query --monitor id)"
  if [[ $monitor_id -eq 1 ]]; then
    owner="$($chunkc tiling::query --window owner)"
    name="$($chunkc tiling::query --window name)"
    echo "${monitor_id};${owner};${name}"
  fi
"""

refreshFrequency: 2500

style: """
  left: 0
  right: 0
  margin: auto
  text-align: center
"""

render: -> """
  <div class="container box" id="window"></div
"""

update: (output, el) ->
  if not output
      return

  args = output.split(";")
  monitorId = (Number) args[0]
  owner = args[1]
  name = args[2]

  if owner != "?"
    txt = $.grep([owner, name], Boolean).join(": ")
  else
    txt = "" 

  $("#window", el).text txt
    