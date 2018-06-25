source $ZPLUG_HOME/init.zsh

# Bundles from oh-my-zsh
zplug 'robbyrussell/oh-my-zsh', use:'lib/*'
zplug "plugins/git", from:oh-my-zsh
#zplug "plugins/tmuxinator", from:oh-my-zsh
#zplug "plugins/shrink-path", from:oh-my-zsh

# Writing
zplug zsh-users/zsh-autosuggestions
# zplug zsh-users/zsh-history-substring-search
zplug zsh-users/zsh-syntax-highlighting

# Versioning
#zplug "paulirish/git-open", as:command
#zplug "rafaeldff/rgit", as:command, use:"rgit"
#zplug "shyiko/commacd", use:"commacd.bash"

# Load the theme
# setopt prompt_subst
zplug "yardnsm/blox-zsh-theme", use:blox.zsh-theme, defer:3
#zplug denysdovhan/spaceship-zsh-theme, use:spaceship.zsh, from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Source plugins and add commands
zplug load

# Apply theme hacks
#function prompt_short_dir { echo "%{$fg_bold[yellow]%}$(shrink_path -f)" }
#PROMPT="$(echo $PROMPT | sed -e 's/\$prompt_dir/\$(prompt_short_dir)/')"

# ORDER
SPACESHIP_PROMPT_ORDER=(
  time          # Time stampts section
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  exec_time     # Execution time
  line_sep      # Line break
  exit_code     # Exit code section
  char          # Prompt character
)

SPACESHIP_PROMPT_SYMBOL="λ"