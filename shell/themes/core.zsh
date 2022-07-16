#!/usr/bin/env zsh

_load_fallback_theme() {
   fpath=("${DOTFILES}/shell/themes" "${DOTFILES}/shell/zsh/completions" $fpath)
   autoload -Uz promptinit
   promptinit
   prompt "${1:-dns}"
}

_load_powerlevel() {
   source "${DOTFILES}/shell/themes/p10k.zsh"
}

case "${DOT_THEME:-}" in
   powerlevel) _load_powerlevel || _load_fallback_theme ;;
   *) _load_fallback_theme ;;
esac

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# case "${DOT_INSTANCE:-}" in
#    devpod*)
#       typeset -g POWERLEVEL9K_DIR_FOREGROUND=45
#       typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=81
#       typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=34
#       ;;
# esac