#!/usr/bin/env bash

_load_fallback_theme() {
   fpath=("${DOTFILES}/shell/themes" "${DOTFILES}/shell/zsh/completions" $fpath)
   autoload -Uz promptinit
   promptinit
   prompt "${1:-dns}"
}

eval "$(starship init zsh 2>/dev/null || echo "_load_fallback_theme")"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
