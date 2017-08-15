command: """
IFS='|' read -r theArtist theName <<<"$(osascript <<<'tell application "Spotify"
        set theTrack to current track
        set theArtist to artist of theTrack
        set theName to name of theTrack
        return theArtist & "|" & theName
    end tell')"
echo "$theArtist - $theName"
"""

refreshFrequency: 2000

style: """
  bottom: 2px
  left: 500px
  color: #fff
  .some-class
    font-size: 10px
"""

render: (output) -> """
	<div class="some-class">#{output}</div>
"""