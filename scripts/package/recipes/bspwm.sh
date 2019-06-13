#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

if ! platform::command_exists bspwm; then
   sudo apt-get install xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev gcc make feh dmenu rofi \
      libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev
   step::shallow_github_clone baskerville bspwm
   step::shallow_github_clone baskerville sxhkd
   step::shallow_github_clone baskerville xdo
   step::shallow_github_clone baskerville sutils
   step::shallow_github_clone baskerville xtitle
   step::shallow_github_clone LemonBoy bar
   step::make bspwm
   step::make sxhkd
   step::make xdo
   step::make sutils
   step::make xtitle
   step::make bar
   echo "sxhkd & exec bspwm" >>$HOME/.xinitrc
   sudo cp "${TMP_FOLDER}/bspwm/contrib/freedesktop/bspwm.desktop" /usr/share/xsessions/
fi