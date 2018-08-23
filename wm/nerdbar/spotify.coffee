command: """
  export TERM=xterm
  RESULTX="$(/usr/local/bin/spotify status 2>/dev/null; echo x)"
  RESULT="${RESULTX%x}"
  echo "$RESULT" | awk ' /rtist/ || /rack/ { $1=""; $2="\b"$2; print $0 }' | sed "N;s/\\n/ - /"
"""

refreshFrequency: 15000

style: """
  right: 90px
  text-align: center
"""

render: -> """
  <div class="container box">
    <span id="song"></span>
    <i class='fa fa-music'></i> 
  </div>
"""

update: (output, el) ->
  if not output
      return

  $("#song", el).text output
    