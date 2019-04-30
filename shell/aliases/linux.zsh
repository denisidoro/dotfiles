#!/usr/bin/env bash
# vim: filetype=sh

open() { 
   dot -d shell open "$@" & disown
 }