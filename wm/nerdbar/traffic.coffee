command: """
  $HOME/.dotfiles/bin/dot -d info network traffic
"""

refreshFrequency: 2000

render: -> """
  <i class='fa fa-arrow-down'></i>
  <span class="amount down bytes"></span><span class="down unit"></span>
"""

style: """
  right: 295px
  .unit
    font: 6px Osaka-Mono
"""

update: (output, el) ->

    usage = (bytes) ->
        kb = bytes / 1024
        usageFormat kb

    usageFormat = (kb) ->
        if kb > 1024
            mb = kb / 1024
            "#{parseFloat(mb.toFixed())}"
        else
            "#{parseFloat(kb.toFixed())}"

    updateStat = (sel, currBytes) ->
        unit = if (currBytes > 1024*1024) then "M" else "K"
        $(el).find(".#{sel}.bytes").text usage(currBytes)
        $(el).find(".#{sel}.unit").text unit

    args = output.split " "

    downBytes = (Number) args[0]
    upBytes = (Number) args[1]

    updateStat 'down', downBytes