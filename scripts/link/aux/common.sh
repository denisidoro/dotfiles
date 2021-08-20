#!/usr/bin/env bash

# Local variables                                                           {{{
# -----------------------------------------------------------------------------

local clone_repository dotdir dotlink linkfiles home_pattern dotdir_pattern
local dotclone_shallow dotset_interactive dotset_verbose diffcmd edit2filecmd
local dot_edit_default_editor columns hrule tp_bold tp_reset
local dotpull_update_submodule

# --------------------------------------------------------------------------}}}
# Default settings                                                          {{{
# -----------------------------------------------------------------------------

clone_repository="${DOT_REPO:-"https://github.com/denisidoro/dotfiles.git"}"

dotdir="${DOT_DIR:-"$HOME/dotfiles"}"
dotlink="${DOT_LINK:-"$dotdir/dotlink"}"
linkfiles=("${dotlink}")

home_pattern="s@$HOME/@@p"
dotdir_pattern="s@${dotdir}/@@p"

dotclone_shallow=false
dotset_interactive=true
dotset_verbose=false
dotpull_update_submodule=true

if hash colordiff 2>/dev/null; then
   diffcmd='colordiff -u'
else
   diffcmd='diff -u'
fi

if hash vimdiff 2>/dev/null; then
   edit2filecmd='vimdiff'
else
   edit2filecmd="${diffcmd}"
fi

# --------------------------------------------------------------------------}}}
# Load user configuration                                                   {{{
# -----------------------------------------------------------------------------

dotbundle() {
   if [ -e "$1" ]; then
      source "$1"
   fi
}

# path to the config file
dotrc="${dotrc:-"$HOME/.config/dot/dotrc"}"
dotbundle "${dotrc}"

# --------------------------------------------------------------------------}}}

# makeline {{{

columns=$(tput cols)
hrule="$( printf '%*s\n' "$columns" '' | tr ' ' - )"

#}}}

# tput {{{

tp_bold="$(tput bold)"
tp_green=$(tput setaf 2)
tp_red=$(tput setaf 1)
tp_reset="$(tput sgr0)"

#}}}

get_fullpath() { #{{{
   echo "$(builtin cd "$(dirname "$1")" && builtin pwd)"/"$(basename "$1")"
} #}}}

path_without_home() { #{{{
   get_fullpath "$1" | sed -ne "${home_pattern}"
} #}}}

path_without_dotdir() { #{{{
   get_fullpath "$1" | sed -ne "${dotdir_pattern}"
} #}}}

__confirm() { #{{{
   # __confirm [ y | n ] [<message>]
   local yn YN confirm ret
   if [ "$1" = "y" ]; then
      yn="y"
      YN="Y/n"
      ret=0
      shift
   elif [ "$1" = "n" ]; then
      yn="n"
      YN="y/N"
      ret=1
      shift
   else
      YN="y/n"
      ret=-1
   fi

   echo -n "$@($YN)> "
   read confirm
   confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
   case $confirm in
      y|yes) return 0 ;;
      n|no) return 1 ;;
      "") if [ $ret -eq -1 ]; then
            echo "Please answer with 'y' or 'n'."
            __confirm $@
         else
            return $ret
         fi
         ;;
      *) echo "Please answer with 'y' or 'n'."
         __confirm $yn $@ ;;
   esac

} #}}}

prmpt() { #{{{
   echo "${tp_bold}$(tput setaf "$1")$2${tp_reset} "
} #}}}

bd_() { #{{{
   echo "${tp_bold}$@${tp_reset}"
} #}}}

rd_() { #{{{
   echo "${tp_red}$@${tp_reset}"
} #}}}

grn_() { #{{{
   echo "${tp_green}$@${tp_reset}"
} #}}}

cleanup_namespace() { #{{{
   unset -f dotbundle get_fullpath path_without_home path_without_dotdir
   unset -f __confirm prmpt bd_ grn_ rd_ dot_usage parse_linkfiles "$0"
} #}}}

parse_linkfiles() { # {{{
   local linkfile l
   local command
   local IFS_BACKUP=$IFS
   IFS=$'\n'

   command="$1"

   for linkfile in "${linkfiles[@]}"; do
      echo "$(prmpt 4 "Loading ${linkfile} ...")"
      for l in $(grep -Ev '^\s*#|^\s*$' "${linkfile}"); do
         # extract environment variables
         dotfile="$(echo "$l" | cut -d, -f1)"
         dotfile="$(eval echo "${dotfile}")"
         orig="$(echo "$l" | cut -d, -f2)"
         orig="$(eval echo "${orig}")"

         # path completion
         [ "${dotfile:0:1}" = "/" ] || dotfile="${dotdir}/$dotfile"
         [ "${orig:0:1}" = "/" ] || orig="$HOME/$orig"

         $command "$dotfile" "$orig"
      done
   done

   IFS=$IFS_BACKUP

} # }}}
