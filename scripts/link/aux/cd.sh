# vim: ft=sh
dot_cd() {
  builtin cd "${dotdir}"
  unset -f $0
} 
