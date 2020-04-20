#!/usr/bin/env zsh

export ZIM_HOME="${DOTFILES}/modules/zimfw"

# prompt
fpath=("${DOTFILES}/shell/zsh/themes" "${DOTFILES}/shell/zsh/completions" $fpath)
autoload -Uz promptinit && promptinit
prompt dns

# on cd (directory changed)
dns_chpwd() {
   # setup profile
   set_profile_based_on_pwd

   # register for jump
   fre --add "$PWD"
}

typeset -gaU chpwd_functions
chpwd_functions+=dns_chpwd

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
# setopt CORRECT

# Customize spelling correction prompt.
# SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
# zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

# Set a custom prefix for the generated git aliases. The default prefix is 'G'.
# zstyle ':zim:git' aliases-prefix 'g'

# Append `../` to your input for each `.` you type after an initial `..`
# zstyle ':zim:input' double-dot-expand yes

# Set a custom terminal title format using prompt expansion escape sequences.
# zstyle ':zim:termtitle' format '%1~'

# Customize the style that the suggestions are shown with
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

# Set what highlighters will be used
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles
# typeset -A ZSH_HIGHLIGHT_STYLES
# ZSH_HIGHLIGHT_STYLES[comment]='fg=10'

# Initialize modules
# Update static initialization script if it's outdated, before sourcing it
if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
   source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh
