source $ZPLUG_HOME/init.zsh

# Bundles from oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
# zplug "plugins/fasd", from:oh-my-zsh

# Writing
zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-history-substring-search
zplug zsh-users/zsh-syntax-highlighting

# Load the theme
zplug "themes/robbyrussell", from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load