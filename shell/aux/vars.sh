#!/usr/bin/env bash
# vim: filetype=sh

# zplug
export ZPLUG_HOME="${DOTFILES}/modules/zplug"

# default editor
export EDITOR='nvim'

# default browser
export BROWSER='google-chrome'

# JVM
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=512M -Xdebug -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export JAVA_TOOLS_OPTIONS='-Dfile.encoding="UTF-8"'

# Clojure
export LEIN_SUPPRESS_USER_LEVEL_REPO_WARNINGS=true

# package management
export HOMEBREW_NO_AUTO_UPDATE=1

# dev
export DEV_HOME="${HOME}/dev"

# PATH
export PATH="${DOTFILES}/local/bin:${DOTFILES}/bin:/usr/local/bin:${PATH}"
export GOPATH="${DEV_HOME}/go"