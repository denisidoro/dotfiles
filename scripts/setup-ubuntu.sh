#!/bin/bash

# Ubuntu

# Initial setup
mkdir -p ~/tmp

# Add third-party repositories
sudo add-apt-repository ppa:git-core/ppa -y
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt-get update -y
sudo apt-get upgrade -y

# Install essential commands
for i in wget git zsh tmux neovim silversearcher-ag fasd; do sudo apt-get install -y $i;

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install tpm
git clone https://github.com/tmux-plugins/tpm --depth=1 ~/.tmux/plugins/tpm

# Setup dot files
cd ~
mkdir -p ~/.config
mkdir -p ~/.config/{nvim,git}
git clone git@github.com:denisidoro/dotfiles.git .dotfiles
bash .dotfiles/install

# Cleanup
rm -rf ~/tmp
cd ~

