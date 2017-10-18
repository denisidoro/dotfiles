command: """
	$HOME/.dotfiles/bin/dot -d info bar all
	# echo "17:51;Wed 06 Sep;100;79.7;58;51.6;31;nu-office;38062;12141"
"""

refreshFrequency: 10050

render: -> """
	<!--<i class='fa fa-arrow-down'></i>
	<span class="down amount"></span><span class="down unit"></span>-->

	<i class='fa fa-volume-up'></i>
	<span id="volume"></span>

	<i class='fa fa-hdd-o'></i>
	<span id="drive"></span>

	<i class='fa fa-microchip'></i>
	<span id="cpu"></span>

	<i class='fa fa-database'></i>
	<span id="memory"></span>

	<i class='fa fa-battery-full battery'></i>
	<span id='battery'></span>

	<i class='fa fa-calendar-o'></i>
	<span id="date"></span>
	<span id="time"></span>
"""

style: """
	right: 10px

	.fa
		margin-left: 2px

	.fa-calendar-o
		margin-left: 10px

	.color1 { color: rgba(5, 102, 141, 1); }
	.color2 { color: rgba(2, 128, 144, 1); }
	.color3 { color: rgba(0, 168, 150, 1); }
	.color4 { color: rgba(2, 195, 154, 1); }
	.color5 { color: rgba(240, 243, 189, 1); }
"""

update: (output, el) ->
	args = output.split(";")

	time = args[0]
	date = args[1]
	battery = parseFloat(((Number) args[2]).toFixed())
	cpu = parseFloat(((Number) args[3]).toFixed())
	drive = parseFloat(((Number) args[4]).toFixed())
	memory = parseFloat(((Number) args[5]).toFixed())
	volume = parseFloat(((Number) args[6]).toFixed())
	down = (Number) args[8]

	$("#time", el).text time
	$("#date", el).text date
	@updateBattery(battery, el)
	$("#memory", el).text memory
	$("#cpu", el).text cpu
	$("#drive", el).text drive
	$("#volume", el).text volume

updateBattery: (n, el) ->
	$("#battery", el).text n
	$icon = $(".fa.battery", el)
	$icon.removeClass()
	$icon.addClass("fa #{@batteryIcon(n)}")

batteryIcon: (n) =>
  return if n > 90
    "fa-battery-full"
  else if n > 70
    "fa-battery-three-quarters"
  else if n > 40
    "fa-battery-half"
  else if n > 20
    "fa-battery-quarter"
  else
    "fa-battery-empty"