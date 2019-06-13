command: """
	$HOME/.dotfiles/bin/dot environment resources fontawesome
"""

refreshFrequency: false

style: """
  height: 20px
  width: 100%
  background-color: #171717
  z-index: -1
"""

render: (output) -> """
	<link rel="stylesheet" type="text/css" href="/nerdbar.widget/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="/nerdbar.widget/base.css">
"""
