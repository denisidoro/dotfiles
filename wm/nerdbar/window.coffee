command: """
  echo $(/usr/local/bin/chunkc tiling::query --desktop id) - \
     $(/usr/local/bin/khd -e 'print mode') - \
     $(/usr/local/bin/chunkc tiling::query --window owner) - \
     $(/usr/local/bin/chunkc tiling::query --window name)
"""

refreshFrequency: 1000 # ms

render: -> """
  <div class="flex-container">
    <div/>
    <div class="container box" id="window"/>
  </div>
"""

style: """
  -webkit-font-smoothing: antialiased
  color: #D6E7EE
  font: 11px Osaka-Mono
  height: 16px
  left: 10px
  overflow: hidden
  text-overflow: ellipsis
  top: 0px
  width: 500px
"""
