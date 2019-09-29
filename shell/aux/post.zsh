#!/usr/bin/env zsh
# vim: filetype=sh

_call_navi() {
   local buff="$BUFFER"
   zle kill-whole-line
   local cmd="$(NAVI_USE_FZF_ALL_INPUTS=true navi --print <> /dev/tty)"
   zle -U "$buff$(echo "$cmd")"
   # zle accept-line
}

zle -N _call_navi

bindkey '^E' _call_navi

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