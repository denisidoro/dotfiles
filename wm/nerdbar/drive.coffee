command: """
	df -h \
		| grep /dev/disk1 \
		| awk '{print $5}' \
		| sed 's/.$//'
"""

refreshFrequency: 60000

render: -> """
	<i class='fa fa-hdd-o'></i>
	<span class="amount"></span>
"""

style: """
	width: 2.75%
	right: 17%
"""

update: (output, el) ->
	n = parseFloat(((Number) output).toFixed())
	$(el).find(".amount").text n