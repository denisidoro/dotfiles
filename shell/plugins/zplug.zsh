source $ZPLUG_HOME/init.zsh

# Bundles from oh-my-zsh
zplug 'robbyrussell/oh-my-zsh', use:'lib/*'
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/tmuxinator", from:oh-my-zsh

# Writing
zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-history-substring-search
zplug zsh-users/zsh-syntax-highlighting

# Versioning
#zplug "paulirish/git-open", as:command
#zplug "rafaeldff/rgit", as:command, use:"rgit"
#zplug "shyiko/commacd", use:"commacd.bash"

# Load the theme
setopt prompt_subst # Make sure propt is able to be generated properly.
zplug "nostophilia/aplos", use:aplos.zsh-theme, defer:3

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
