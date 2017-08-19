command: """
	/usr/local/bin/chunkc tiling::query --desktop id
"""

refreshFrequency: 1000

render: (output) -> """
	<span class="amount"></span>
"""

style: """
	left: 2px
"""

update: (output, el) ->
	$(el).find(".amount").text output