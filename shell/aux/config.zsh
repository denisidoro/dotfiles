#!/usr/bin/env bash
# vim: filetype=sh

# ===============
# fzf
# ===============
FZF_DEFAULT_OPTS='--height 40%'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ===============
# fasd
# ===============
eval "$(fasd --init posix-alias zsh-hook)"

# ===============
# syntax highlighting
# ===============
# ZSH_HIGHLIGHT_STYLES[path]='bold'
# ZSH_HIGHLIGHT_STYLES[reserved-word]=none

# ===============
# autosuggestions
# ===============
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
