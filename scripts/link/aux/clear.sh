# vim:ft=sh
dot_clear() {

  _dot_clear() { #{{{
    local orig
    
    orig="$2"

    if [ -L "${orig}" ]; then
      unlink "${orig}"
      echo "$(prmpt 1 unlink)${orig}"
    fi
  } #}}}

  parse_linkfiles _dot_clear

  unset -f _dot_clear $0
}
