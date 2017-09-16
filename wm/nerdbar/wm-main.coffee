command: """
	monitor_id="$(/usr/local/bin/chunkc tiling::query --monitor id)"
	desktop_id="$(/usr/local/bin/chunkc tiling::query --desktop id)"
	mode="$(/usr/local/bin/khd -e 'print mode')"
    window_name="$(/usr/local/bin/chunkc tiling::query --window owner)"
	echo "${monitor_id};${desktop_id};${mode};${window_name}"
"""

refreshFrequency: 2500

render: (output) -> """
	<span class="amount"></span>
"""

style: """
	left: 10px
"""

update: (output, el) ->
    args = output.split ";"
    monitorId = (Number) args[0]
    desktopId = (Number) args[1]
    mode = args[2].replace /^\s+|\s+$/g, ""
    windowName = args[3]
    if monitorId == 1
        if mode != "default"
            out = "#{desktopId} - #{mode} | #{windowName}"
        else
            out = "#{desktopId} | #{windowName}"
        $(el).find(".amount").text out
