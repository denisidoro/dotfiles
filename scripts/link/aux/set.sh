# vim: ft=sh
dot_set() {
  # option handling
  local arg
  local dotset_ignore=false
  local dotset_force=false
  local dotset_create_dirs=false
  local dotset_backup=false
  local dotset_verbose=false

  for arg in "$@"; do
    shift
    case "$arg" in
      "--ignore" ) set -- "$@" "-i" ;;
      "--force"  ) set -- "$@" "-f" ;;
      "--create-dirs"|"p" ) dotset_create_dirs=true ;;
      "--backup" ) set -- "$@" "-b" ;;
      "--verbose") set -- "$@" "-v" ;;
                *) set -- "$@" "$arg" ;;
    esac
  done

  OPTIND=1

  while getopts ifbv OPT; do
  echo "opt: $OPT"
    case $OPT in
      "i" ) dotset_ignore=true ;;
      "f" ) dotset_force=true ;;
      "b" ) dotset_backup=true ;;
      "v" ) dotset_verbose=true ;;
    esac
  done

  check_dir() { #{{{
    local orig="$1"

    origdir="${orig%/*}"

    [ -d "${origdir}" ] && return 0

    echo "$(prmpt 1 error)$(bd_ ${origdir}) doesn't exist."

    ${dotset_ignore} && return 1

    if ! ${dotset_force} && ! ${dotset_create_dirs}; then
      __confirm y "make directory $(bd_ ${origdir}) ? " || return 1
    fi
    mkdir -p "${origdir}" && return 0
  } #}}}

  replace() { #{{{
    # replace "${orig}" "${dotfile}"
    if [ -d "$1" ]; then
      rm -rf -- "$1"
    else
      rm -f -- "$1"
    fi
    ln -s "$2" "$1"
    echo "$(prmpt 2 done)$1"
  } #}}}

  replace_and_backup() { #{{{
    # replace_and_backup "${orig}" "${dotfile}"
    backuped="$1$(date +'_%Y%m%d_%H%M%S')"
    mv -i "$1" "${backuped}"
    ln -s "$2" "$1"
    echo "$(prmpt 2 done)$1"
    echo "$(prmpt 2 "make backup")${backuped}"
  } #}}}

  if_islink() { #{{{
    local orig="$1"
    local dotfile="$2"
    local linkto="$(readlink "${orig}")"

    # if the link has already be set: do nothing
    if [ "${linkto}" = "${dotfile}" ]; then
      ${dotset_verbose} && echo "$(prmpt 2 exists)${orig}"
      return 0
    fi

    echo "$(prmpt 1 conflict)Other link already exists at $(bd_ ${orig})"

    ${dotset_ignore} && return 0

    if ! ${dotset_force}; then
      echo -n "  $(prmpt 2 now)"
      echo "${orig} $(tput setaf 5)<--$(tput sgr0) ${linkto}"
      echo -n "  $(prmpt 3 try)"
      echo "${orig} $(tput setaf 5)<--$(tput sgr0) ${dotfile}"
      __confirm n "Unlink and re-link for $(bd_ ${orig}) ? " || return 0
    fi
    unlink "${orig}"
    ln -s "${dotfile}" "${orig}"
    echo "$(prmpt 2 done)${orig}"

    return 0
  } #}}}

  if_exist() { #{{{
    # local line
    local orig="$1"
    local dotfile="$2"

    if ${dotset_ignore}; then
      echo "$(prmpt 1 conflict)File already exists at $(bd_ ${orig})."
      return 0
    fi

    if ${dotset_force}; then
      replace "${orig}" "${dotfile}"
      return 0
    fi

    if ${dotset_backup}; then
      replace_and_backup "${orig}" "${dotfile}"
      return 0
    fi

    while true; do
      echo "$(prmpt 1 conflict)File already exists at $(bd_ ${orig})."
      echo "Choose the operation:"
      echo "    ($(bd_ d)):show diff"
      echo "    ($(bd_ e)):edit files"
      echo "    ($(bd_ f)):replace"
      echo "    ($(bd_ b)):replace and make backup"
      echo "    ($(bd_ n)):do nothing"
      echo -n ">>> "; read line
      case $line in
        [Dd] )
          eval "${diffcmd}" "${dotfile}" "${orig}"
          echo ""
          ;;
        [Ee] )
          eval "${edit2filecmd}" "${dotfile}" "${orig}"
          ;;
        [Ff] )
          replace "${orig}" "${dotfile}"
          break
          ;;
        [Bb] )
          replace_and_backup "${orig}" "${dotfile}"
          break
          ;;
        [Nn] )
          break
          ;;
        *)
          echo "Please answer with [d/e/f/b/n]."
          ;;
      esac
    done

    return 0
  } #}}}

  _dot_set() { #{{{
    local dotfile orig
    dotfile="$1"
    orig="$2"

    # if dotfile doesn't exist, print error message and pass
    if [ ! -e "${dotfile}" ]; then
      echo "$(prmpt 1 "not found")${dotfile}"
      return 1
    fi

    # if the targeted directory doesn't exist,
    # ask whether make directory or not.
    check_dir "${orig}" || return 1

    if [ -e "${orig}" ]; then                    # if the file already exists:
      if [ -L "${orig}" ]; then                  #   if it is a symbolic-link:
        if_islink "${orig}" "${dotfile}"         #      do nothing or relink
      else                                       #   if it is a file or a dir:
        if_exist "${orig}" "${dotfile}"          #      ask user what to do
      fi                                         #
    else                                         # else:
      readlink "${orig}" 1>/dev/null && unlink "${orig}"
      ln -s "${dotfile}" "${orig}"               #   make symbolic link
      test $? && echo "$(prmpt 2 done)${orig}"
    fi

  } #}}}

  parse_linkfiles _dot_set

  unset -f check_dir if_islink if_exist _dot_set replace replace_and_backup $0
}
