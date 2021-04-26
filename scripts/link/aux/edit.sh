# vim: ft=sh
dot_edit() {
  # init
  if [ ! -e "${dotlink}" ]; then
    echo "$(prmpt 1 empty)$(bd_ ${dotlink})"
    if __confirm y "make dotlink file ? " ; then
      echo "cp ${DOT_SCRIPT_ROOTDIR}/examples/dotlink ${dotlink}"
      cp "${DOT_SCRIPT_ROOTDIR}/examples/dotlink" "${dotlink}"
    else
      echo "Aborted."; return 1
    fi
  fi

  # open dotlink file
  if [ -n "${dot_edit_default_editor}" ];then
    eval ${dot_edit_default_editor} "${dotlink}"
  elif hash "$EDITOR" 2>/dev/null; then
    $EDITOR "${dotlink}"
  else
    xdg-open "${dotlink}"
  fi

  unset -f $0
}
