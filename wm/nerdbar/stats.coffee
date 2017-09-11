command: """
	# $HOME/.dotfiles/bin/dot -d info bar all
	echo "17:51;Wed 06 Sep;100;79.7;58;51.6;31;nu-office;38062;12141"
"""

refreshFrequency: 100000

render: -> """
<ul class="powerline">
  <li class="left">
    <div><a href="#">* 176 UUU-:</a><a href="#">*scratch*</a></div>
    <div class="endsection"></div>
    <div><a href="#">Lizsp</a></div>
    <div class="shrinkable"><a href="#">Interaction SP Helm Undo-Tree company</a></div>
    <div class="endsection"></div>
  </li>
  <div class="center"><a href="#"> 8e4c32f32ec869fe521fb4d3c0a69406830b4178</a></div>
  <li class="right">
    <div class="endsection"></div>
    <div class="value2"><span id="date"></span></div>
    <div class="endsection"></div>
    <div class="value2"><span id="time"></span></div>
  </li>
</ul>
"""

style: """
	width: 100%

	.value2 {
		padding-top: 3px
  		font: 12px Osaka-Mono
	    color: #f0f0f0;
	}

	.value2 span {
		margin-left: -7px
		margin-right: -7px
	}

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

	$(el).find("#time").text time
	$(el).find("#date").text date
