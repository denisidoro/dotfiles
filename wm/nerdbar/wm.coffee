command: """
	desktop_id="$(/usr/local/bin/chunkc tiling::query --desktop id)"
	mode="$(/usr/local/bin/khd -e 'print mode')"
	if [[ $mode = "default" ]]; then
		echo "$desktop_id"
	else
		echo "$desktop_id - $mode"
	fi
"""

refreshFrequency: 1000

render: (output) -> """
	<span class="amount"></span>
"""

style: """
	left: 10px
"""

update: (output, el) ->
	$(el).find(".amount").text output