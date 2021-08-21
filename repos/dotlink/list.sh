#!/usr/bin/env bash

dot_list() {
   _dot_list() {
      echo "$1","$2"
   }

   parse_linkfiles _dot_list

   unset -f _dot_list "$0"
}
