command: """
	$HOME/.dotfiles/bin/dot info bar all
	# echo "21:44;01-Jan;94;31.9;40.9;62;Wi-Fi;KitKat"
"""

refreshFrequency: 10050

render: -> """
	<div class="container right">
		<span class="box network color4">
			<!--<i class='fa fa-network-down'></i>--> 
			<span class="desc" id="network"></span>
		</span>
		<span class="box cpu color4">
			<!--<i class='fa fa-plus'></i>--> 
			<span class="desc">cpu</span>
			<span id="cpu">0</span>
		</span>
		<span class="box memory color4">
			<!--<i class='fa fa-folder'></i>-->
			<span class="desc">mem</span>
			<span id="memory">0</span>
		</span>
		<span class="box volume color4">
			<!--<i class='fa fa-volume-down'></i>-->
			<span class="desc">vol</span>
			<span id="volume">0</span>
		</span>
		<span class="box battery color4">
			<!--<i class='fa fa-bolt'></i>--> 
			<span class="desc">bat</span>
			<span id="battery">80</span>
		</span>
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
	battery = args[2]
	cpu = args[3]
	memory = args[4]
	volume = args[5]
	network = args[6]

	$("#time", el).text time
	$("#battery", el).text battery
	$("#cpu", el).text cpu
	$("#memory", el).text memory
	$("#volume", el).text volume
	$("#network", el).text network
	