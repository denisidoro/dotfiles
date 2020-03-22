#!/usr/bin/env bash
# vim: filetype=sh

alias vim='nvim'
# alias subl='subl -a'
unalias s &> /dev/null
alias subl="subl -a"
alias s="dot_or_args subl --"
alias v="dot_or_args nvim --"
