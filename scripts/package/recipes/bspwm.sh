#!/usr/bin/env bash
# vim: filetype=sh

package::install() {
   sudo apt-get install xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev gcc make feh dmenu rofi \
      libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev

   recipe::shallow_github_clone baskerville bspwm
   recipe::shallow_github_clone baskerville sxhkd
   recipe::shallow_github_clone baskerville xdo
   recipe::shallow_github_clone baskerville sutils
   recipe::shallow_github_clone baskerville xtitle
   recipe::shallow_github_clone LemonBoy bar
   recipe::make bspwm
   recipe::make sxhkd
   recipe::make xdo
   recipe::make sutils
   recipe::make xtitle
   recipe::make bar

   echo "sxhkd & exec bspwm" >> $HOME/.xinitrc

   sudo cp "${TMP_FOLDER}/bspwm/contrib/freedesktop/bspwm.desktop" /usr/share/xsessions/
}