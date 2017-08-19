command: """
	date +\"%a %d %b\"
"""

refreshFrequency: 60000

render: -> """
  <i class='fa fa-calendar-o'></i>
  <span class="amount"></span>
"""

style: """
  right: 60px
"""

update: (output, el) ->
	$(el).find(".amount").text output
