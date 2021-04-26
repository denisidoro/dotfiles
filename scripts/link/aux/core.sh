#!/usr/bin/env bash
# vim: ft=zsh
# dotlink - dotfiles management framework

# Version:             2.0.0
# Original repository: https://github.com/ssh0/dot
# Original author:     ssh0 (Shotaro Fujimoto)
# Repository:          https://github.com/denisidoro/dotlink
# Author:              denisidoro (Denis Isidoro)
# License:             MIT

if [[ -z "${DOT_SCRIPT_ROOTDIR:-}" ]]; then
   export DOT_SCRIPT_ROOTDIR="${DOTFILES}/scripts/link"
   readonly DOT_SCRIPT_ROOTDIR
   export DOT_SCRIPT_ROOTDIR
fi

dotlink_main() {

   dot_usage() { #{{{
      cat << EOF
dotlink - Simplest dotfiles manager

Usage:
  dotlink [options] <commands> [<args>]
  dotlink pull [--self]
  dotlink (set | update) [-i | --ignore] [-f | --force] [-b | --backup] [-v | --verbose] [-p | --create-dirs]
  dotlink add (<file> [$DOT_DIR/path/to/the/file]) | <symboliclinks>...
  dotlink unlink <symboliclinks>...
  dotlink clear
  dotlink clone [-f | --force] [/dir/to/clone]
  dotlink (-h | --help)

Commands:
  clone   Clone dotfile repository on your computer with git.
  pull    Pull the directory from the remote dotfiles repository.
  cd      Change directory to 'dotdir'.
  list    Show the list which files will be managed by dotlink.
  check   Check the files are correctly linked to the right places.
  set     Set the symbolic links interactively.
  update  Combined command of 'pull' and 'set' commands.
  add     Move the file to the dotfiles directory and make its symbolic link to that place.
  edit    Edit dotlink file.
  unlink  Unlink the selected symbolic links and copy from its original.
  clear   Remove the all symbolic links in 'dotlink'.
  config  Edit (or create if it does not exist) rcfile 'dotrc'.

Options:
  -h, --help                     Show this help message.
  -H, --help-all                 Show man page.
  -c <file>, --config <file>     Specify the configuration file to load.
                                 default: \$HOME/.config/dot/dotrc

EOF

   } #}}}

   # Option handling {{{
   local arg
   for arg in "$@"; do
      shift
      case "$arg" in
         "--help") set -- "$@" "-h" ;;
         "--help-all") set -- "$@" "-H" ;;
         "--config") set -- "$@" "-c" ;;
         *)        set -- "$@" "$arg" ;;
      esac
   done

   OPTIND=1
   local dotrc
   while getopts "c:hH" OPT
   do
      case $OPT in
         "c")
            dotrc="$OPTARG"
            ;;
         "h")
            dot_usage
            unset -f dot_usage
            return 0
            ;;
         "H")
            man "${DOT_SCRIPT_ROOTDIR}/doc/dot.1"
            unset -f dot_usage
            return 0
            ;;
         * )
            dot_usage
            unset -f dot_usage
            return 1
            ;;
      esac
   done

   shift $((OPTIND-1))
   # }}}

   # Load common.sh {{{
   source "$DOT_SCRIPT_ROOTDIR/aux/common.sh"
   trap cleanup_namespace EXIT
   # }}}

   # main command handling {{{
   case "$1" in
      clone|pull|update|list|check|set|add|edit|unlink|clear|config|cd)
         subcommand="$1"
         source "$DOT_SCRIPT_ROOTDIR/aux/${subcommand}.sh"
         shift 1
         dot_${subcommand} "$@"
         ;;
      *)
         echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
         echo "command $(tput bold)$1$(tput sgr0) not found."
         return 1
         ;;
   esac

   # }}}

}

(return 0 2>/dev/null) || dotlink_main "$@"
