# vim: ft=sh
dot_check() {

  _dot_check() { #{{{
    local dotfile orig origdir linkto message
    local delimiter=","
    dotfile="$1"
    orig="$2"
    message="${dotfile}${delimiter}${orig}"

    # if dotfile doesn't exist
    if ! [[ -e "${dotfile}" || -e "${orig}" || -L "${orig}" ]]; then
      echo "$(prmpt 1 ✘)${message}"
      return 1
    fi

    linkto="$(readlink "${orig}")"

    if [ "${linkto}" = "${dotfile}" ]; then
      echo "$(prmpt 2 ✔)${message}"
    else
      echo "$(prmpt 1 ✘)${message}"
    fi
    return 0
  } #}}}
  
  parse_linkfiles _dot_check

  unset -f _dot_check $0
} 
