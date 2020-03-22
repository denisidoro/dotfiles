#!/usr/bin/env bash
# vim: filetype=sh

# zplug
export ZPLUG_HOME="${DOTFILES}/modules/zplug"

# default editor
export EDITOR='vim'

# default browser
export BROWSER='google-chrome'

# default pager
export PAGER='less'

# locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# JVM
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=512M -Xdebug -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n"
export JAVA_TOOLS_OPTIONS='-Dfile.encoding="UTF-8"'

# dev
export DEV_HOME="${HOME}/dev"

# Clojure
export LEIN_SUPPRESS_USER_LEVEL_REPO_WARNINGS=true

# Golang
export GOPATH="${DEV_HOME}/go"

# package management
export HOMEBREW_NO_AUTO_UPDATE=1

# fasd/z.lua/jump
export _ZL_CMD=zlua
# export _ZL_DATA="${DOTFILES}/modules/.z_lua"
export _ZL_MATCH_MODE=1

# fzf
export FZF_DEFAULT_OPTS='--height 70% --reverse --inline-info --cycle'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# security
export GPG_TTY=$(tty)

# x11
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
export XENVIRONMENT="${XENVIRONMENT:-"${HOME}/.Xresources"}"

# navi
export NAVI_PATH="${DOTFILES}/cheats:${DOTFILES}/local/cheats"

# PATH
export PATH="${DOTFILES}/local/bin:${DOTFILES}/bin:/usr/local/bin:${PATH}:${HOME}/.cargo/bin"
