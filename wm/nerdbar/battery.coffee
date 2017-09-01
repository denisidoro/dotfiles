command: """
	pmset -g batt \
		| egrep '([0-9]+\%).*' -o --colour=auto \
		| cut -f1 -d';' \
		| sed 's/.$//'
"""

refreshFrequency: 150000

render: (output) -> """
  <i class='fa fa-battery-full'></i>
  <span class='amount'></span>
"""

style: """
  width: 40px
  right: 130px
"""

update: (output, el) ->
	n = (Number) output
	$(".amount", el).text n
	$icon = $(".fa", el)
	$icon.removeClass()
	$icon.addClass("fa #{@batteryIcon(n)}")

batteryIcon: (percentage) =>
  return if percentage > 90
    "fa-battery-full"
  else if percentage > 70
    "fa-battery-three-quarters"
  else if percentage > 40
    "fa-battery-half"
  else if percentage > 20
    "fa-battery-quarter"
  else
    "fa-battery-empty"
