# vim: ft=sh
dot_pull() {
  if [ "$1" = "--self" ]; then
    echo $(prmpt 4 "Update dot")
    git -C "${DOT_SCRIPT_ROOTDIR}" pull
  else
    # git pull
    echo "$(prmpt 4 "Update dotfiles")git -C "${dotdir}" pull"
    git -C "${dotdir}" pull
    if ${dotpull_update_submodule} && test -s "${dotdir}/.gitmodules"; then
      echo "$(prmpt 4 "Update the submodules ...")"
      git -C "${dotdir}" submodule init
      git -C "${dotdir}" submodule update
    fi
  fi

  unset -f $0
}
