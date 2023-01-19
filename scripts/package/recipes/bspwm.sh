#!/usr/bin/env bash
set -euo pipefail

package::install() {
   sudo apt-get install xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev gcc make feh dmenu rofi \
      libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev

   recipe::shallow_github_clone baskerville bspwm
   recipe::shallow_github_clone baskerville sxhkd
   recipe::shallow_github_clone baskerville xdo
   recipe::shallow_github_clone baskerville sutils
   recipe::shallow_github_clone baskerville xtitle
   recipe::shallow_github_clone LemonBoy bar
   recipe::install bspwm
   recipe::install sxhkd
   recipe::install xdo
   recipe::install sutils
   recipe::install xtitle
   recipe::install bar

   echo "sxhkd & exec bspwm" >> "$HOME"/.xinitrc

   sudo cp "${TMP_FOLDER}/bspwm/contrib/freedesktop/bspwm.desktop" /usr/share/xsessions/
}