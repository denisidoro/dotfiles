command: """
	date +\"%H:%M\"
"""

refreshFrequency: 10000

render: -> """
  <i class='fa fa-clock-o'></i>
  <span class="amount"></span>
"""

style: """
  right: 10px
"""

update: (output, el) ->
	$(el).find(".amount").text output
