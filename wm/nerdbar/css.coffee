command: """
	$HOME/.dotfiles/bin/dot -d environment resources fontawesome
"""

refreshFrequency: false

render: (output) -> """
	<link rel="stylesheet" type="text/css" href="/nerdbar.widget/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="/nerdbar.widget/base.css">
"""
