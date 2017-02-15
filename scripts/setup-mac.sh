#!/bin/bash

# Ubuntu

# Initial setup
echo "THIS IS UNTESTED. USE CAREFULLY"
mkdir -p ~/tmp

# Install essential commands
for i in wget git zsh tmux neovim silversearcher-ag fasd ruby
do 
  brew install $i
done

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install tpm
git clone https://github.com/tmux-plugins/tpm --depth=1 ~/.tmux/plugins/tpm

# Install tmuxinator
gem install tmuxinator

# Setup dot files
cd ~
mkdir -p ~/.config
mkdir -p ~/.config/{nvim,git}
git clone git@github.com:denisidoro/dotfiles.git .dotfiles
bash .dotfiles/install

# Cleanup
rm -rf ~/tmp
cd ~

