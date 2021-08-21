#!/usr/bin/env bash
set -euo pipefail

_brew_osx() {
   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

_brew_linux() {
   if has apt; then
      if sudo apt update && sudo apt-get install -y build-essential curl file git; then return 0; fi
   elif has yum; then
      if sudo yum groupinstall 'Development Tools' && sudo yum install curl file git; then return 0; fi
   fi

   sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

   test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
   test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
   test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.bash_profile
   echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.profile
}

_brew_apt() {
   sudo apt update
   sudo apt install linuxbrew-wrapper
}

recipe::is_installed() {
   has brew || fs::is_dir /home/linuxbrew
}

package::install() {
   dot pkg add git || true
   dot pkg add ruby || true

   if platform::is_osx; then
      _brew_osx
   elif has apt; then
      _brew_apt || _brew_linux
   else
      _brew_linux
   fi

   brew update || (brew vendor-install ruby && brew update)
}
