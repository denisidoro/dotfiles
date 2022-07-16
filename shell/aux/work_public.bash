#!/usr/bin/env zsh

export DOT_DOCOPT=${DOT_DOCOPT:-"docpars"}
export DOT_THEME=${DOT_THEME:-powerlevel}

export PATH="${PATH}:${WORK_BINARIES_PATH}:/usr/local/opt/bash/bin/:/usr/local/bin:${HOMEBREW_PREFIX}/sbin:${HOMEBREW_PREFIX}/bin"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-11.0.11.jdk/Contents/Home"

export NPM_CONFIG_REGISTRY="https://registry.npmjs.org/"
export GOOGLE_CLOUD_SDK_HOME="${DEV_HOME}/google-cloud-sdk"

# JS
export VOLTA_HOME="${HOME}/.volta"
export NVM_DIR="${HOME}/.nvm"

# Golang
export GOPATH="${DEV_HOME}/go"
export GOBIN="${GOPATH}/bin"

source "${DOTFILES}/shell/aliases/osx.bash"

alias ls='exa --icons'

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

alias ysa="killall Dock; sudo yabai --install-sa; sudo yabai --load-sa"

_load_work_stuff() {
   case $1 in
      go)
         gopathmode on
         ;;
      gcloud)
         source "${HOME}/google-cloud-sdk/path.zsh.inc" &> /dev/null
         # source "${HOME}/google-cloud-sdk/completion.zsh.inc" &> /dev/null
         ;;
      nvm)
         if ! ${NVM_LOADED:-false}; then
            unset -f nvm node npm &> /dev/null
            dot script log info "Loading nvm..."
            [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
            export NVM_LOADED=true
         else
            dot script log info "nvm already loaded!"
         fi
         ;;
      rbenv)
         if ! ${RBENV_LOADED:-false}; then
            dot script log info "Loading rbenv..."
            type "rbenv" > /dev/null && eval "$(command rbenv init - --no-rehash)"
            export RBENV_LOADED=true
         else
            dot script log info "rbenv already loaded!"
         fi
         ;;
      lda)
         dot script log info "Loading lda..."
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
         dot script log info "Loading bazel..."
         case "$(basename $SHELL)" in
            zsh)
               zstyle ':completion:*' use-cache on
               zstyle ':completion:*' cache-path ~/.zsh/cache
               ;;
            *) source /usr/local/etc/bash_completion.d/bazel-complete.bash || true ;;
         esac
         ;;
      virtualenv)
         if [ -z "${_VIRTUALENVWRAPPER_API}" ]; then
            dot script log info "Loading virtualenv..."
            [ -s "${HOMEBREW_PREFIX}/bin/virtualenvwrapper_lazy.sh" ] && . "${HOMEBREW_PREFIX}/bin/virtualenvwrapper_lazy.sh"
         else
            dot script log info "virtualenv already loaded!"
         fi
         ;;
      direnv)
         dot script log info "Loading direnv..."
         eval "$(direnv hook $SHELL)"
         ;;
      *)
         return 1
         ;;
   esac
}

zsh_disable_lda() {
   unset LDA_ENABLED
}

zsh_enable_lda() {
   export LDA_ENABLED=1
}

bash_disable_lda() {
   unset LDA_ENABLED
}

bash_enable_lda() {
   export LDA_ENABLED=1
}

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

gopathmode() {
   USAGE="$0 [ on | off ]\n\tshows or sets MONOREPO_GOPATH_MODE"
   [ $# -lt 1 ] && {
      [ -n "$MONOREPO_GOPATH_MODE" ] \
         && dot script log info "MONOREPO_GOPATH_MODE is on." \
         || dot script log info "MONOREPO_GOPATH_MODE is off."
      return
   }

   [ $# -gt 1 ] && dot script log info "$USAGE" && return
   [ "$1" != "on" ] && [ "$1" != "off" ] && {
      dot script log info "$USAGE"
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
