#!/bin/bash

# <bitbar.title>chunkwm/skhd helper</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Shi Han NG</bitbar.author>
# <bitbar.author.github>shihanng</bitbar.author.github>
# <bitbar.desc>Plugin that displays desktop id and desktop mode of chunkwm.</bitbar.desc>
# <bitbar.dependencies>brew,chunkwm,skhd</bitbar.dependencies>

export PATH=/usr/local/bin:$PATH
export DOTFILES=${DOTFILES:-$HOME/.dotfiles}

case "$1" in
  stop) "$DOTFILES/bin/dot" app wm stop ;;
  restart) "$DOTFILES/bin/dot" app wm stop ;;
esac

#desktop="$(/usr/local/bin/chunkc tiling::query --desktop id)"
#if [[ $desktop < 6 ]]; then
#  desktop_display_1=$desktop
#else 
#  desktop_display_2=$desktop
#fi
#echo "${desktop_display_1:-no}:${desktop_display_2:-no}"

echo "$(/usr/local/bin/chunkc tiling::query --desktop id)"
echo "---"
echo "Restart WM | bash='$0' param1=restart terminal=false"
echo "Stop WM | bash='$0' param1=stop terminal=false"
