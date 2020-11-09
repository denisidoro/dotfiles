#!/usr/bin/env zsh

_load_fallback_theme() {
   fpath=("${DOTFILES}/shell/themes" "${DOTFILES}/shell/zsh/completions" $fpath)
   autoload -Uz promptinit
   promptinit
   prompt "${1:-dns}"
}

_load_starship() {
   zmodload zsh/parameter  # Needed to access jobstates variable for NUM_JOBS

   starship_precmd() {
      STATUS=$?

      NUM_JOBS=$#jobstates
      if [[ ! -z "${STARSHIP_START_TIME+1}" ]]; then
         STARSHIP_END_TIME=$("starship" time)
         STARSHIP_DURATION=$((STARSHIP_END_TIME - STARSHIP_START_TIME))
         PROMPT="$("starship" prompt --status=$STATUS --cmd-duration=$STARSHIP_DURATION --jobs="$NUM_JOBS")"
         unset STARSHIP_START_TIME
      else
         PROMPT="$("starship" prompt --status=$STATUS --jobs="$NUM_JOBS")"
      fi
   }

   starship_preexec() {
      STARSHIP_START_TIME=$("starship" time)
   }

   [[ -z "${precmd_functions+1}" ]] && precmd_functions=()
   [[ -z "${preexec_functions+1}" ]] && preexec_functions=()

   if [[ ${precmd_functions[(ie)starship_precmd]} -gt ${#precmd_functions} ]]; then
      precmd_functions+=(starship_precmd)
   fi

   if [[ ${preexec_functions[(ie)starship_preexec]} -gt ${#preexec_functions} ]]; then
      preexec_functions+=(starship_preexec)
   fi

   zle-keymap-select() {
      PROMPT=$("starship" prompt --keymap=$KEYMAP --jobs="$(jobs | wc -l)")
      zle reset-prompt
   }

   STARSHIP_START_TIME=$("starship" time)
   zle -N zle-keymap-select
   export STARSHIP_SHELL="zsh"
}

_load_powerlevel() {
   source "${DOTFILES}/shell/themes/p10k.zsh"
}

case "${DOT_THEME:-}" in
   powerlevel) _load_powerlevel || _load_fallback_theme ;;
   starship) _load_starship || _load_fallback_theme ;;
   *) _load_fallback_theme ;;
esac

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
