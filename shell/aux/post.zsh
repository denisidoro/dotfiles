#!/usr/bin/env zsh
# vim: filetype=sh

# fzf
if ${DOT_FZF:-false}; then
   if [ $SHELL = "fzf" ]; then
      source "${DOTFILES}/shell/bindings/${SH}.zsh"
   fi
   source "${HOME}/.fzf.${SH}" 2> /dev/null || true
fi

# fasd
if ${DOT_FASD:-false}; then
   eval "$(lua "${DOTFILES}/modules/z.lua/z.lua" --init "$SH" enhanced once)" 2> /dev/null || true
fi