#!/usr/bin/env bash
# vim: filetype=sh

# zplug
export ZPLUG_HOME="${DOTFILES}/modules/zplug"

# set editor
export EDITOR='nvim'

# add folders to PATH
export PATH="$DOTFILES/local/bin:$DOTFILES/bin:/usr/local/bin:${PATH}"
