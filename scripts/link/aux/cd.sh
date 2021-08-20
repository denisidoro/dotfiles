#!/usr/bin/env bash

dot_cd() {
   builtin cd "${dotdir}" || exit
   unset -f "$0"
}
