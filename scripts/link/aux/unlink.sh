# vim: ft=sh
dot_unlink() {
   local f

   for f in "$@"; do
      if [ ! -L "$f" ]; then
         echo "$(prmpt 1 error)$(bd_ $f) is not the symbolic link."
         continue
      fi

      # get the file's path
      local currentpath="$(get_fullpath "$f")"

      # get the absolute path
      local abspath="$(readlink "$f")"

      # unlink the file
      unlink "$currentpath"

      # copy the file
      cp -r "$abspath" "$currentpath"

      echo "$(prmpt 1 unlink)$f"
      echo "$(prmpt 2 copy)$abspath"
   done

   unset -f $0
}
