#!/usr/bin/env zsh

export DOT_DOCOPT=${DOT_DOCOPT:-"python"}
export DOT_FZF=${DOT_FZF:-true}
export DOT_NAVI=${DOT_NAVI:-true}
export DOT_FRE=${DOT_FRE:-true}
export DOT_STARSHIP=${DOT_STARSHIP:-true}
export DOT_ZIM=${DOT_ZIM:-true}

export PATH="${WORK_BINARIES_PATH}:${PATH}"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_251.jdk/Contents/Home"

_load() {
   case $1 in
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
            autoload -Uz add-zsh-hook
            # for zsh, only enable LDA before running the command
            # and disable it just before printing the prompt
            add-zsh-hook preexec zsh_enable_lda
            add-zsh-hook precmd zsh_disable_lda
         elif [[ ! -z "$JENKINS_HOME" ]]; then
            # do nothing on jenkins
            :
         elif [[ $- == *i* ]]; then
            # interactive bash shell, use PROMPT_COMMAND to hook in pre-execution
            bash_enable_lda
         else
            # non-interactive bash shell
            :
         fi
         ;;
      bazel)
         echoerr "Loading bazel..."
         case $PROFILE_SHELL in
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
   esac
}

_nvm() {
   _load nvm || true
   nvm "$@"
}

_node() {
   _load nvm || true
   node "$@"
}

_npm() {
   _load nvm || true
   npm "$@"
}

rbenv() {
   unfunction "$0" || true
   _load rbenv || true
   "$0" "$@"
}

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
