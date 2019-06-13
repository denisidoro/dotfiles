#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

_brew_osx() {
   /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

_brew_linux() {
   if platform::command_exists apt; then
     sudo apt update && sudo apt-get install -y build-essential curl file git
   elif platform::command_exists yum; then
     sudo yum groupinstall 'Development Tools' && sudo yum install curl file git
   fi

   sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
   
   test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
   test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
   test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.bash_profile
   echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.profile
}

_brew_apt() {
   sudo apt update
   sudo apt install linuxbrew-wrapper
}

if ! platform::command_exists brew && ! fs::is_dir /home/linuxbrew && feedback::confirmation "Do you want to install brew?"; then
   log::note "Installing brew..."
   if platform::is_osx; then
      _brew_osx
   elif platform::command_exists apt; then
      _brew_apt || _brew_linux
   else
      _brew_linux
   fi
fi
