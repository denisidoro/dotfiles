#!/bin/bash

# Ubuntu

# Third-party repositories
sudo add-apt-repository ppa:git-core/ppa -y
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt-get update -y
sudo apt-get upgrade -y

# Essential commands
sudo apt-get install curl -y
sudo apt-get install wget -y
sudo apt-get install git -y
sudo apt-get install zsh -y
sudo apt-get install tmux -y
sudo apt-get install neovim -y
sudo apt-get install unzip -y

# Setup dot files
cd ~
mkdir -p ~/.config
mkdir -p ~/.config/{nvim,git}
git clone git@github.com:denisidoro/dotfiles.git .dotfiles
bash .dotfiles/install

# Cleanup
rm -rf ~/tmp
cd ~

