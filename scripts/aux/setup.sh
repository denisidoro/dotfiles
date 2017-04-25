#!/usr/bin/env bash

function setup_apt() {

  # Add commons 
  sudo apt-get install software-properties-common

  # Add third-party repositories
  for repository in $(from_dependencies "apt-repositories")
  do
    sudo add-apt-repository $repository -y
  done
  sudo apt-get update -y
  sudo apt-get upgrade -y

  # Install essential commands
  for package in $(from_dependencies "brew-apt" "apt")
  do 
  sudo apt-get install -y $package
done

}

function setup_brew() {

  # Install brew
  if ! command_exists brew ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # Install essential commands
  for package in $(from_dependencies "brew-apt" "brew")
  do
    brew install $package
  done

}

function setup() {

  # Initial setup
  sudo mkdir -p $HOME/tmp
  package_manager=$(get_package_manager)
  dependencies=$(read_dependencies)
  if [[ -z "$package_manager" ]]; then
    echo "Unable to find compatible install commands for your platform. Aborting..."
    exit 1
  else
    echo "Detected package manager: $package_manager"
  fi

  # Invoke platform-specific setup
  case $package_manager in
    brew) setup_brew;;
    apt) setup_apt;;
  esac

  # Install fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  $HOME/.fzf/install

  # Install vim-plug
  curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  http://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # Install tpm
  git clone https://github.com/tmux-plugins/tpm --depth=1 $HOME/.tmux/plugins/tpm

  # Install tmuxinator
  gem install tmuxinator

  # Setup dotfiles
  cd $HOME/.dotfiles
  bash install

  # Cleanup
  rm -rf $HOME/tmp
  cd $HOME

}
