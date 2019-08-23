#!/usr/bin/env bash
# vim: filetype=sh

source $ZPLUG_HOME/init.zsh

# Bundles from oh-my-zsh
zplug 'robbyrussell/oh-my-zsh', use:'lib/*'
zplug "plugins/git", from:oh-my-zsh
#zplug "plugins/tmuxinator", from:oh-my-zsh
#zplug "plugins/shrink-path", from:oh-my-zsh

# Writing
zplug zsh-users/zsh-autosuggestions
#zplug zsh-users/zsh-history-substring-search
#zplug zsh-users/zsh-syntax-highlighting

# Versioning
#zplug "paulirish/git-open", as:command
#zplug "rafaeldff/rgit", as:command, use:"rgit"
#zplug "shyiko/commacd", use:"commacd.bash"

# Load the theme
# setopt prompt_subst
#zplug "yardnsm/blox-zsh-theme", use:blox.zsh-theme, defer:3
#zplug denysdovhan/spaceship-zsh-theme, use:spaceship.zsh, from:github, as:theme
zplug "themes/juanghurtado", from:oh-my-zsh, as:theme

# Install plugins if there are plugins that have not been installed
#if ! zplug check --verbose; then
#    printf "Install? [y/N]: "
#    if read -q; then
#        echo; zplug install
#    fi
#fi

# Source plugins and add commands
zplug load

# Apply theme hacks
#function prompt_short_dir { echo "%{$fg_bold[yellow]%}$(shrink_path -f)" }
PROMPT='
%{$GREEN_BOLD%}%{$YELLOW%}%~%u %{$GREEN_BOLD%}$(git_current_branch)%{$RESET_COLOR%}
%{$BLUE%}λ%{$RESET_COLOR%} '
RPROMPT=''
# PROMPT='%{$GREEN_BOLD%}%{$YELLOW%}%~%u$(parse_git_dirty)$(git_prompt_ahead)%{$RESET_COLOR%}%{$BLUE%}λ%{$RESET_COLOR%} '
# RPROMPT='%{$GREEN_BOLD%}$(git_current_branch)$(git_prompt_short_sha)$(git_prompt_status)%{$RESET_COLOR%}'