#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/git.sh"

git_pager=$(git config core.pager || echo 'less')

export GIT_GI_REPO_REMOTE=${GIT_GI_REPO_REMOTE:-https://github.com/dvcs/gitignore}
export GIT_GI_REPO_LOCAL=${GIT_GI_REPO_LOCAL:-"${HOME}/.git/gi/repos/dvcs/gitignore"}
export GIT_GI_TEMPLATES=${GIT_GI_TEMPLATES:-"${GIT_GI_REPO_LOCAL}/templates"}

GIT_FZF_DEFAULT_OPTS="
${FZF_DEFAULT_OPTS}
--ansi
--height='80%'
--bind='alt-k:preview-up,alt-p:preview-up'
--bind='alt-j:preview-down,alt-n:preview-down'
--bind='ctrl-r:toggle-all'
--bind='ctrl-s:toggle-sort'
--bind='?:toggle-preview'
--bind='alt-w:toggle-preview-wrap'
--preview-window='right:60%'
${GIT_FZF_DEFAULT_OPTS}
"