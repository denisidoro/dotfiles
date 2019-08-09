#!/usr/bin/env bash
# vim: filetype=sh

export DOT_INSTALL_NAME="$(echo "$(whoami) $(hostname)")"
export DOT_INSTALL_EMAIL="$(echo "$(whoami)@$(hostname)")"
export DOT_INSTALL_DOCOPTS="go"
export DOT_INSTALL_BACKUP=true
export DOT_INSTALL_NVIM=true
export DOT_INSTALL_SUDO=true
export DOT_INSTALL_FZF=false
export DOT_INSTALL_FASD=false
export DOT_INSTALL_BREW=false
export DOT_INSTALL_BATCH=false
export DOT_INSTALL_NVIM_PLUGINS=false
export DOT_INSTALL_TMUX_PLUGINS=false
export DOT_INSTALL_ZPLUG_PLUGINS=false
