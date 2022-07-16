#!/usr/bin/env zsh

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
   bindkey ${terminfo[kcuu1]} history-substring-search-up
   bindkey ${terminfo[kcud1]} history-substring-search-down
fi

# Bind more keys
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# autocomplete
# sudo chmod g-w /usr/local/share/zsh/site-functions
#  sudo chmod g-w /usr/local/share/zsh
# export POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# set path for completions
fpath=("${DOTFILES}/shell/zsh/completions" $fpath)
autoload -U compinit && compinit