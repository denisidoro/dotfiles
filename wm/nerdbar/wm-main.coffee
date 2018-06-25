command: """
    chunkc=/usr/local/bin/chunkc
	monitor_id="$($chunkc tiling::query --monitor id)"
    # desktops=$($chunkc tiling::query --desktops-for-monitor $monitor_id)
	desktop_id="$($chunkc tiling::query --desktop id)"
    windows=$($chunkc tiling::query --desktop windows | gwc -l)
	echo "${monitor_id};${desktop_id};${windows}"
"""

refreshFrequency: 2500

render: (output) -> """
    <span class="wm hidden" id="wm1"></span>
    <span class="wm hidden" id="wm2"></span>
    <span class="wm hidden" id="wm3"></span>
    <span class="wm hidden" id="wm4"></span>
    <span class="wm hidden" id="wm5"></span>
    <span class="wm hidden" id="wm6"></span>
    <span class="wm hidden" id="wm7"></span>
    <span class="wm hidden" id="wm8"></span>
    <span class="wm hidden" id="wm9"></span>
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
