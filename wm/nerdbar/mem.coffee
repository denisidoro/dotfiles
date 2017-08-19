command: """
	ESC=$(printf \"\e\")
	ps -A -o %mem \
    | awk '{s+=$1} END {print \"\" s}'
"""

refreshFrequency: 2500

render: (output) -> """
	<i class='fa fa-database'></i>
	<span class="amount"></span>
"""

style: """
	right: 185px
"""

update: (output, el) ->
	n = parseFloat(((Number) output).toFixed())
	$(el).find(".amount").text n