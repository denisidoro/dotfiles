# vim: ft=sh
dot_add() {
  # default message
  local message=""

  # option handling
  while getopts m:h OPT
  do
    case $OPT in
      "m" ) message="${OPTARG}";;
    esac
  done

  shift $((OPTIND-1))

  if [ ! -e "$1" ]; then
    echo "$(prmpt 1 error)$(bd_ $1) doesn't exist."
    return 1
  fi

  orig_to_dot() { #{{{
    # mv from original path to dotdir
    local orig dot

    orig="$(get_fullpath "$1")"
    dot="$(get_fullpath "$2")"

    mv -i "${orig}" "${dot}"

    # link to orig path from dotfiles
    ln -siv "${dot}" "${orig}"
  } #}}}

  add_to_dotlink() { #{{{
    local dotfile linkto
    # add the configration to the config file.
    [ -n "${message}" ] && echo "# ${message}" >> "${dotlink}"

    dotfile="$(path_without_dotdir "$2")"
    if [ "${dotfile}" = "" ]; then
      dotfile="$(path_without_home "$2")"
      if [ -n ${dotfile} ]; then
        dotfile="\$HOME/${dotfile}"
      else
        dotfile="$(get_fullpath "$2")"
      fi
    fi

    linkto="$(path_without_home "$1")"
    linkto="${linkto:="$(get_fullpath "$1")"}"

    echo "${dotfile},${linkto}" >> "${dotlink}"

    if [ $? = 0 ]; then
      echo "Successfully added the new file to dotfiles"
      echo "To edit the links manually, execute \`${DOT_COMMAND} edit\`"
    fi
  } #}}}

  if_islink() { #{{{
    # write to dotlink
    local f abspath

    for f in "$@"; do
      if [ ! -L "$f" ]; then
        echo "$(prmpt 1 error)$(bd_ $1) is not the symbolic link."
        continue
      fi

      # get the absolute path
      abspath="$(readlink "$f")"

      if [ ! -e "${abspath}" ]; then
        echo -n "$(prmpt 1 error)Target path $(bd_ ${abspath}) doesn't exist."
        return 1
      fi

      # write to dotlink
      add_to_dotlink "$f" "${abspath}"
    done
  } #}}}

  suggest() { #{{{
    echo "$(prmpt 6 suggestion)"
    echo "    dot add -m '${message}' $1 ${dotdir}/$(path_without_home "$1")"
    __confirm n "Continue? " || return 1

    dot_add_main "$1" "${dotdir}/$(path_without_home $1)"
  } #}}}

  check_dir() { #{{{
    if [ -d "${1%/*}" ]; then
      return 0
    fi

    echo "$(prmpt 1 error)$(bd_ ${1%/*}) doesn't exist."
    if __confirm y "make directory $(bd_ ${1%/*}) ? "; then
      mkdir -p "${1%/*}"
      return 0
    fi

    return 1

  } #}}}

  dot_add_main() { #{{{
    # if the first arugument is a symbolic link
    if [ -L "$1" ]; then
      if_islink "$@" || return 1
      return 0
    fi

    # if the second arguments is provided (default action)
    if [ $# = 2 ]; then

      # if the targeted directory doesn't exist,
      # ask whether make directory or not.
      check_dir "$2" || return 1

      orig_to_dot "$1" "$2"
      add_to_dotlink "$1" "$2"

      return 0
    fi

    # if the second arugument isn't provided, provide suggestion
    if [ $# = 1 ];then
      suggest "$1" && return 0 || return 1
    fi

    # else
    echo "$(prmpt 1 error)Aborted."
    echo "Usage: 'dot add file'"
    echo "       'dot add file ${dotdir}/any/path/to/the/file'"

    return 1
  } #}}}

  dot_add_main "$@"

  unset -f orig_to_dot add_to_dotlink if_islink suggest check_dir
  unset -f $0
}
