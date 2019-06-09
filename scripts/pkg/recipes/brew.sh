#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/pkg/aux/recipes.sh"

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


# ==============================
# Vimplug
# ==============================

recipe::vimplug() {
   if ! fs::is_file "$HOME/.local/share/nvim/site/autoload/plug.vim"; then
      curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
         http://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   fi
}


# ==============================
# Spacevim
# ==============================

recipe::spacevim() {
   cat "$HOME/.config/nvim/init.vim" 2>/dev/null \
      | grep -q "space-vim" 2>/dev/null \
      || bash <(curl -fsSL https://raw.githubusercontent.com/liuchengxu/space-vim/master/install.sh)
}


# ==============================
# TPM
# ==============================

recipe::tpm() {
   if ! fs::is_dir "$HOME/.tmux/plugins/tpm"; then
      git clone https://github.com/tmux-plugins/tpm --depth=1 $HOME/.tmux/plugins/tpm
   fi
}


# ==============================
# Tmuxinator
# ==============================

recipe::tmuxinator() {
   if ! platform::command_exists tmuxinator; then
      gem install tmuxinator
   fi
}


# ==============================
# GNU utils
# ==============================

recipe::gnu() {
   if ! platform::command_exists ggrep; then
      brew tap homebrew/dupes
      brew install binutils diffutils ed findutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gzip screen watch wget && brew install wdiff --with-gettext
      brew install bash m4 make nano file-formula git less openssh rsync unzip
   fi
}


# ==============================
# Kitty
# ==============================

recipe::kitty() {
   if ! platform::command_exists kitty; then
      step::shallow_github_clone kovidgoyal kitty
      step::make kitty
   fi
}


# ==============================
# BSPWM
# ==============================

recipe::bspwm() {
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
}


# ==============================
# Spacemacs
# ==============================

recipe::spacemacs() {
   if ls ~/.emacs.d/ | grep -q spacemacs || false; then
      git clone https://github.com/syl20bnr/spacemacs --depth 1 ~/.emacs.d
   fi
}


# ==============================
# Watchman
# ==============================

recipe::watchman() {
   if ! platform::command_exists watchman; then
      sudo apt-get install -y autoconf automake build-essential python-dev
      step::shallow_github_clone facebook watchman
      cd "${TMP_FOLDER}/watchman"
      ./autogen.sh
      ./configure
      step::make watchman
   fi
}


# ==============================
# ag: the-silver-searcher
# ==============================

recipe::ag() {
   if ! platform::command_exists ag; then
      apt-get install silversearcher-ag \
         || brew install the_silver_searcher \
         || yum install the_silver_searcher
   fi
}


# ==============================
# nvim
# ==============================

recipe::nvim() {
   if platform::command_exists brew; then
      brew install neovim
   else
      cd "$HOME"
      sudo curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
      chmod u+x nvim.appimage
      sudo mv nvim.appimage /usr/local/nvim
   fi
}
