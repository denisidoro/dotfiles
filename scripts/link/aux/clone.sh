# vim: ft=sh
dot_clone() {
   local cloneto clonecmd
   local arg
   local dotclone_force=false

   for arg in "$@"; do
      shift
      case "$arg" in
         "--force"  ) dotclone_force=true ;;
         "-f"       ) dotclone_force=true ;;
         *          ) set -- "$@" "$arg" ;;
      esac
   done

   cloneto="${1:-"${dotdir}"}"

   if ${dot_clone_shallow}; then
      clonecmd="git clone --recursive --depth 1 ${clone_repository} ${cloneto}"
   else
      clonecmd="git clone --recursive ${clone_repository} ${cloneto}"
   fi

   echo "$(prmpt 3 try): ${clonecmd}"
   if ! ${dotclone_force}; then
      if ! __confirm y "Continue? "; then
         echo "Aborted."
         echo ""
         echo "If you want to clone other repository, change environment variable DOT_REPO."
         echo "    export DOT_REPO=https://github.com/Your_Username/dotfiles.git"
         echo "Set the directory to clone by:"
         echo "    dot clone ~/dotfiles"
         echo "    export DOT_DIR=\$HOME/dotfiles"
         return 1
      fi
   fi

   eval "${clonecmd}"

   if [ -s "${cloneto}/.gitmodules" ]; then
      echo "$(prmpt 4 "Initialize the submodules")"
      git -C "${cloneto}" submodule init
      git -C "${cloneto}" submodule update
   fi

   unset -f $0
}
