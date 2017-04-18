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
  brew install binutils diffutils ed findutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gzip screen watch  wget && brew install wdiff --with-gettext
  brew install bash emacs m4 make nano file-formula git less openssh rsync unzip
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

  echo "Attempting to update submodules..."
  (git pull && git submodule init && git submodule update && git submodule status && \
    cd "${DOTFILES}" && git submodule update --init --recursive "${DOTBOT_DIR}" || true) > /dev/null

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
