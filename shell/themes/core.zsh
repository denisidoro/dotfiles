#!/usr/bin/env zsh

_load_fallback_theme() {
   fpath=("${DOTFILES}/shell/themes" "${DOTFILES}/shell/zsh/completions" $fpath)
   autoload -Uz promptinit
   promptinit
   prompt "${1:-dns}"
}

_load_starship() {
   # ZSH has a quirk where `preexec` is only run if a command is actually run (i.e
   # pressing ENTER at an empty command line will not cause preexec to fire). This
   # can cause timing issues, as a user who presses "ENTER" without running a command
   # will see the time to the start of the last command, which may be very large.

   # To fix this, we create STARSHIP_START_TIME upon preexec() firing, and destroy it
   # after drawing the prompt. This ensures that the timing for one command is only
   # ever drawn once (for the prompt immediately after it is run).

   zmodload zsh/parameter  # Needed to access jobstates variable for NUM_JOBS

   # Will be run before every prompt draw
   starship_precmd() {
      # Save the status, because commands in this pipeline will change $?
      STATUS=$?

      # Use length of jobstates array as number of jobs. Expansion fails inside
      # quotes so we set it here and then use the value later on.
      NUM_JOBS=$#jobstates
      # Compute cmd_duration, if we have a time to consume
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

   # If precmd/preexec arrays are not already set, set them. If we don't do this,
   # the code to detect whether starship_precmd is already in precmd_functions will
   # fail because the array doesn't exist (and same for starship_preexec)
   [[ -z "${precmd_functions+1}" ]] && precmd_functions=()
   [[ -z "${preexec_functions+1}" ]] && preexec_functions=()

   # If starship precmd/preexec functions are already hooked, don't double-hook them
   # to avoid unnecessary performance degradation in nested shells
   if [[ ${precmd_functions[(ie)starship_precmd]} -gt ${#precmd_functions} ]]; then
      precmd_functions+=(starship_precmd)
   fi
   if [[ ${preexec_functions[(ie)starship_preexec]} -gt ${#preexec_functions} ]]; then
      preexec_functions+=(starship_preexec)
   fi

   # Set up a function to redraw the prompt if the user switches vi modes
   zle-keymap-select() {
      PROMPT=$("starship" prompt --keymap=$KEYMAP --jobs="$(jobs | wc -l)")
      zle reset-prompt
   }

   STARSHIP_START_TIME=$("starship" time)
   zle -N zle-keymap-select
   export STARSHIP_SHELL="zsh"
}

if ${DOT_STARSHIP:-true}; then
   _load_starship || _load_fallback_theme
else
   _load_fallback_theme
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)