command: """
	$HOME/.dotfiles/bin/dot -d environment resources fontawesome
"""

refreshFrequency: false

style: """
  height: 20px
  width: 100%
  z-index: -1
"""

render: (output) -> """
	<link rel="stylesheet" type="text/css" href="/nerdbar.widget/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="/nerdbar.widget/base.css">
	<div class="flex-container color3">
		
		<div class="left-box">
			<span class="box wm">1</span>
			<span class="box wm color2">2</span>
			<span class="box wm">3</span>
		</div>
		
		<div class="center-box">
			Firefoxaaaa
		</div>
		
		<div class="right-box">
			<span class="box down color4">
				<i class='fa fa-chevron-down'></i>
				2M
			</span>
			<span class="box battery color1">
				<i class='fa fa-heart'></i>
				80%
			</span>
			<span class="box time color2">
				<i class='fa fa-clock-o'></i>
				20:35
			</span>
		</div>

	</div>
"""
