#!/usr/bin/env bash
set -euo pipefail

GITCONFIG_PATH="${DOTFILES}/local/gitconfig"

package::is_installed() {
   [ -f "$GITCONFIG_PATH" ]
}

_git_name() {
   echo "$(whoami) $(hostname)"
}

_git_email() {
   echo "$(whoami)@$(hostname)"
}

_content() {
   DOT_GIT_NAME="${DOT_GIT_NAME:-$(_git_name)}"
   DOT_GIT_EMAIL="${DOT_GIT_EMAIL:-$(_git_email)}"

   echo "[user]"
   echo "   name = ${DOT_GIT_NAME}"
   echo "   email = ${DOT_GIT_EMAIL}"
}

package::install() {
   dot pkg add dot-folders
   dot pkg add $EDITOR

   touch "$GITCONFIG_PATH"
   _content > "$GITCONFIG_PATH"
   $EDITOR "$GITCONFIG_PATH"
}
