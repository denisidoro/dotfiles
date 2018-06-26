command: """
    chunkc=/usr/local/bin/chunkc
	monitor_id="$($chunkc tiling::query --monitor id)"
    if [[ $monitor_id -eq 1 ]]; then
        desktop_id="$($chunkc tiling::query --desktop id)"
        windows=$($chunkc tiling::query --desktop windows | wc -l)
    	echo "${monitor_id};${desktop_id};${windows}"
    fi
"""

refreshFrequency: 2500

render: (output) -> """
    <div class="container">
        <span class="box wm hidden" id="wm1">1</span>
        <span class="box wm hidden" id="wm2">2</span>
        <span class="box wm hidden" id="wm3">3</span>
        <span class="box wm hidden" id="wm4">4</span>
        <span class="box wm hidden" id="wm5">5</span>
        <span class="box wm hidden" id="wm6">6</span>
        <span class="box wm hidden" id="wm7">7</span>
        <span class="box wm hidden" id="wm8">8</span>
        <span class="box wm hidden" id="wm9">9</span>
    </div>
"""

style: """
	left: 0px
"""

update: (output, el) ->
    if not output
        return

    args = output.split ";"
    monitorId = (Number) args[0]
    desktopId = (Number) args[1]
    windows = (Number) args[2]

    i = 1
    while i <= 9
        id = "#wm" + i
        if i == desktopId
            if windows > 0
                $(id).removeClass("hidden")
            else 
                $(id).addClass("hidden")
            $(id).addClass("active")
        else 
            $(id).removeClass("active")
        i += 1
