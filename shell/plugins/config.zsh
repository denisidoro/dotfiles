# ===============
# fzf
# ===============
FZF_DEFAULT_OPTS='--height 40%'
FZF_DEFAULT_COMMAND='ag -g ""'
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# ===============
# fasd 
# ===============
eval "$(fasd --init posix-alias zsh-hook 2> /dev/null)"


# ===============
# syntax highlighting
# ===============
ZSH_HIGHLIGHT_STYLES[path]='bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]=none


# ===============
# autosuggestions
# ===============
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
