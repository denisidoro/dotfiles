command: """
	$HOME/.dotfiles/bin/dot -d info bar all
	# echo "17:51;Wed 06 Sep;100;79.7;58;51.6;31;nu-office;38062;12141"
"""

refreshFrequency: 10050

render: -> """
	<div class="container right">
		<!--<span class="box down color4">
			<i class='fa fa-chevron-down'></i>
			<span id="down">2M</span>
		</span>-->
		<!--<span class="box battery color2">
			<i class='fa fa-heart'></i>
			<span id="battery">80%</span>
		</span>-->
		<span class="box time color1">
			<i class='fa fa-clock-o'></i>
			<span id="time">20:35</span>
		</span>
	</div>
"""

style: """
	right: 0px
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
	$("#battery", el).text battery
	