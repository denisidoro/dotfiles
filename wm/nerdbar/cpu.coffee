command: """
	ESC=$(printf \"\e\")
	ps -A -o %cpu \
    | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'
"""

refreshFrequency: 3500

render: -> """
	<i class='fa fa-tasks'></i>
	<span class="amount"></span>
"""

style: """
	width: 2.75%
	right: 14.5%
"""

update: (output, el) ->
	n = parseFloat(((Number) output).toFixed())
	$(el).find(".amount").text n