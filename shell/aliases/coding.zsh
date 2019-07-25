#!/usr/bin/env bash
# vim: filetype=sh

alias vim='nvim'
# alias subl='subl -a'
alias subl='code'
unalias s &> /dev/null
alias s="dot_or_args code --"
alias v="dot_or_args nvim --"