#!/usr/bin/env zsh

export DOT_DOCOPT=${DOT_DOCOPT:-"docpars"}
export DOT_FZF=${DOT_FZF:-true}
export DOT_NAVI=${DOT_NAVI:-true}
export DOT_FRE=${DOT_FRE:-true}
export DOT_THEME=${DOT_THEME:-powerlevel}
export DOT_ZIM=${DOT_ZIM:-true}

export PATH="/usr/local/bin:${HOMEBREW_PREFIX}/sbin:${HOMEBREW_PREFIX}/bin:${WORK_BINARIES_PATH}:/usr/local/opt/bash/bin/:${PATH}"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_251.jdk/Contents/Home"

# source "${HOME}/.gradle/jv1/.gradle/caches/okbuck/buck-completion.bash"
# source "${HOME}/.config/broot/launcher/bash/br"

alias ls='exa --icons'

alias xdg-open='open'

alias sed='gsed'
alias awk='gawk'
alias find='gfind'
alias grep='ggrep'
alias head='ghead'
alias mktemp='gmktemp'
# alias ls='gls'
alias date='gdate'
alias cut='gcut'
alias tr='gtr'
# alias cp='gcp'
alias cat='gcat'
alias sort='gsort'
alias kill='gkill'
alias xargs='gxargs'
alias base64='gbase64'

alias mono="dot u mono"

_load_work_stuff() {
   case $1 in
      go)
         gopathmode on
         ;;
      gcloud)
         source "${HOME}/google-cloud-sdk/path.zsh.inc" &> /dev/null
         source "${HOME}/google-cloud-sdk/completion.zsh.inc" &> /dev/null
         ;;
      nvm)
         if ! ${NVM_LOADED:-false}; then
            unset -f nvm node npm &> /dev/null
            echoerr "Loading nvm..."
            [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
            export NVM_LOADED=true
         else
            echoerr "nvm already loaded!"
         fi
         ;;
      rbenv)
         if ! ${RBENV_LOADED:-false}; then
            echoerr "Loading rbenv..."
            type "rbenv" > /dev/null && eval "$(command rbenv init - --no-rehash)"
            export RBENV_LOADED=true
         else
            echoerr "rbenv already loaded!"
         fi
         ;;
      lda)
         echoerr "Loading lda..."
         if [ -n "$ZSH_VERSION" ]; then
            # autoload -Uz add-zsh-hook
            # for zsh, only enable LDA before running the command
            # and disable it just before printing the prompt
            # add-zsh-hook preexec zsh_enable_lda
            # add-zsh-hook precmd zsh_disable_lda
            :
         elif [[ ! -z "$JENKINS_HOME" ]]; then
            # do nothing on jenkins
            :
         elif [[ $- == *i* ]]; then
            # interactive bash shell, use PROMPT_COMMAND to hook in pre-execution
            # bash_enable_lda
            :
         else
            # non-interactive bash shell
            :
         fi
         ;;
      bazel)
         echoerr "Loading bazel..."
         case ${DOT_SHELL:-} in
            zsh)
               zstyle ':completion:*' use-cache on
               zstyle ':completion:*' cache-path ~/.zsh/cache
               ;;
            *) source /usr/local/etc/bash_completion.d/bazel-complete.bash ;;
         esac
         ;;
      virtualenv)
         if [ -z "${_VIRTUALENVWRAPPER_API}" ]; then
            echoerr "Loading virtualenv..."
            [ -s "${HOMEBREW_PREFIX}/bin/virtualenvwrapper_lazy.sh" ] && . "${HOMEBREW_PREFIX}/bin/virtualenvwrapper_lazy.sh"
         else
            echoerr "virtualenv already loaded!"
         fi
         ;;
      direnv)
         echoerr "Loading direnv..."
         eval "$(direnv hook $SHELL)"
         ;;
      *)
         return 1
         ;;
   esac
}

# _nvm() {
#    _load_work_stuff nvm || true
#    nvm "$@"
# }
#
# _node() {
#    _load_work_stuff nvm || true
#    node "$@"
# }
#
# _npm() {
#    _load_work_stuff nvm || true
#    npm "$@"
# }
#
# rbenv() {
#    unfunction "$0" || true
#    _load_work_stuff rbenv || true
#    "$0" "$@"
# }

zsh_disable_lda() {
   if [[ ! -z "$WORK_BINARIES_PATH" ]]; then
      export PATH=${PATH//"${WORK_BINARIES_PATH}:"/}
      unset LDA_ENABLED
   fi
}

zsh_enable_lda() {
   if [[ -z "$LDA_ENABLED" ]]; then
      export PATH="$WORK_BINARIES_PATH:$PATH"
      export LDA_ENABLED=1
   fi
}

bash_enable_lda() {
   if [[ ! -z "$LDA_ENABLED" ]]; then
      return
   fi
   export LDA_ENABLED=1

   if [[ -z "$PROMPT_COMMAND" ]]; then
      PROMPT_COMMAND='[[ "$PATH" =~ "pex_resource" ]] || export PATH="$WORK_BINARIES_PATH:$PATH"'
   else
      PROMPT_COMMAND='[[ "$PATH" =~ "pex_resource" ]] || export PATH="$WORK_BINARIES_PATH:$PATH"'";$PROMPT_COMMAND"
   fi
}

# run brew --prefix only once in script, even if sourced again in same shell
# [ "${HOMEBREW_PREFIX-no}"=="no" ] || type "brew" &>/dev/null && export HOMEBREW_PREFIX=$(brew --prefix)
# [ "${HOMEBREW_PREFIX-no}"=="no" ] || export PATH=${HOMEBREW_PREFIX}/sbin:${HOMEBREW_PREFIX}/bin:$PATH

export VAGRANT_DEFAULT_PROVIDER=aws
export HOMEBREW_NO_SANDBOX=1
export HOMEBREW_PREFIX="/usr/local"
export VIRTUALENVWRAPPER_PYTHON="${HOMEBREW_PREFIX}/bin/python2.7"
export VIRTUALENVWRAPPER_SCRIPT="${HOMEBREW_PREFIX}/bin/virtualenvwrapper.sh"

_sync_dir() {
   cmd=$1
   shift
   new_directory=$(boxer sync_dir $@)
   if [ "$?" -eq "0" ]; then
      $cmd $new_directory
   else
      echo "$new_directory"
   fi
}

cdsync() {
   _sync_dir cd $@
}

editsync() {
   _sync_dir $EDITOR $@
}

opensync() {
   _sync_dir open @
}

# if command -v rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# eval "$(direnv hook zsh)"

gopathmode() {
   USAGE="$0 [ on | off ]\n\tshows or sets MONOREPO_GOPATH_MODE"
   [ $# -lt 1 ] && {
      [ -n "$MONOREPO_GOPATH_MODE" ] \
         && echo "MONOREPO_GOPATH_MODE is on." \
         || echo "MONOREPO_GOPATH_MODE is off."
      return
   }
   [ $# -gt 1 ] && echo "$USAGE" && return
   [ "$1" != "on" ] && [ "$1" != "off" ] && {
      echo "$USAGE"
      return
   }

   if [[ "$MONOREPO_GOPATH_MODE" != "1" && "$1" == "on" ]] ; then
      _load_work_stuff direnv
      _load_work_stuff bazel
      export MONOREPO_GOPATH_MODE=1

      repo=$(git config --get remote.origin.url || true)
      if [[ $repo =~ ":go-code" ]]; then
         direnv reload
      fi
   elif [[ -n "$MONOREPO_GOPATH_MODE" && "$1" == "off" ]] ; then
      unset MONOREPO_GOPATH_MODE
      repo=$(git config --get remote.origin.url || true)
      if [[ $repo =~ ":go-code" ]]; then
         direnv reload
      fi
   fi
}
