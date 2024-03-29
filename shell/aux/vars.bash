#!/usr/bin/env bash

# dotfiles
export DOT_INSTANCE="mac"

# default editor
export EDITOR='v'

# default browser
export BROWSER='vivaldi'

# default pager
export PAGER='less'

# locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# JVM
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=512M -Xdebug -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n"
export JAVA_TOOLS_OPTIONS='-Dfile.encoding="UTF-8"'

# bookmarks
export DEV_HOME="${HOME}/dev"

# Clojure
export LEIN_SUPPRESS_USER_LEVEL_REPO_WARNINGS=true

# package management
export HOMEBREW_NO_AUTO_UPDATE=1

# fzf
export FZF_DEFAULT_OPTS='--height 70% --reverse --inline-info --cycle'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# x11
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
export XENVIRONMENT="${XENVIRONMENT:-"${HOME}/.Xresources"}"

# navi
# export NAVI_PATH="${DOTFILES}/cheats:${DOTFILES}/local/cheats"
# export NAVI_PATH="${DOTFILES}/cheats/demo"

# zsh
export ZDOTDIR="${ZDOTDIR:-"${HOME}/.zim"}"
export ZIM_HOME="${ZIM_HOME:-"$ZDOTDIR"}"

# PATH
export PATH="${DOTFILES}/local/bin:${DOTFILES}/bin:${HOME}/.cargo/bin:${HOME}/bin:${HOME}/.cargo/bin:${VOLTA_HOME}/bin:${GOBIN}:${HOME}/.local/bin:${PATH}"
