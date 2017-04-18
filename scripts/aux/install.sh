#!/bin/bash

brew_install() {
  for repository in "$(from_dependencies "$@")"
  do
    brew install "$repository"
  done
}

cask_install() {
  for repository in "$(from_dependencies "$@")"
  do
    brew cask install "$repository"
  done
}

gnu_install() {
  brew tap homebrew/dupes
  brew install binutils && brew install diffutils && brew install ed && brew install findutils && brew install gawk && \
    brew install gnu-indent && brew install gnu-sed && brew install gnu-tar && brew install gnu-which && brew install gnutls && \
    brew install grep && brew install gzip && brew install screen && brew install watch && brew install wdiff --with-gettext && \
    brew install wget
  brew install bash && brew install m4 && brew install make && brew install nano && brew install file-formula && \
    brew install git && brew install less && brew install openssh && brew install rsync && brew install unzipi
}

update_dotfiles_common() {

  DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
  CONFIG="$DOTFILES/scripts/conf.yaml"
  DOTBOT_DIR="modules/dotbot"
  DOTBOT_BIN="bin/dotbot"

  echo "Setting folder architecture..."
  mkdir -p "$HOME/.config/{nvim,git,karabiner}"
  mkdir -p "$DOTFILES/local/bin"
  pushd . > /dev/null
  cd $DOTFILES

  echo "Updating submodules..."
  (git pull && git submodule init && git submodule update && git submodule status && \
    cd "${DOTFILES}" && git submodule update --init --recursive "${DOTBOT_DIR}") > /dev/null

  echo
  "${DOTFILES}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${DOTFILES}" -c "${CONFIG}" "${@}" 
  echo

  # Neovim
  echo "Installing neovim plugins..."
  nvim +silent +PlugInstall +qall > /dev/null

  # Tmux
  echo "Installing tpm plugins..."
  export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/"
  bash "${TMUX_PLUGIN_MANAGER_PATH}tpm/bin/install_plugins" > /dev/null
  bash "${TMUX_PLUGIN_MANAGER_PATH}tpm/bin/update_plugins" all > /dev/null

  # ZPlug
  echo "Attempting to install ZPlug plugins..."
  zplug install 2> /dev/null

  # Cleanup
  popd > /dev/null

}

update_dotfiles_osx() {
  echo "No custom dotfiles for OSX yet"
}

read_dependencies() {
  echo "$(cat "$DOTFILES/scripts/dependencies.txt")\n\n"
}

from_dependencies() {
  # install ggrep if not installed on OSX
  if is_osx; then
    if ! command_exists ggrep; then
      brew tap homebrew/dupes
      brew install homebrew/dupes/grep
    fi
  fi

  for key in "$@"
  do
    echo "$dependencies" | grep -Pzo "^$key:\n(.|\n)*?\n{2}" | tail -n +2 | sed '/^$/d'                
  done
}
