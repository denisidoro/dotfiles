#!/usr/bin/env bash

dot_config() {
   # init
   if [ ! -e "${dotrc}" ]; then
      echo "$(prmpt 1 error)$(bd_ "${dotrc}") doesn't exist."
      if __confirm y "make configuration file ? "; then
         printf "mkdir -p ${dotrc//dotrc} ... "
         mkdir -p "${dotrc//dotrc}"
         if [ -d "${dotrc//dotrc}" ]; then echo "$(grn_ Success.)"; else echo "$(rd_ Failure. Aborted.)"; return 1; fi
         printf "cp ${DOT_SCRIPT_ROOTDIR}/examples/dotrc ${dotrc} ... "
         cp "${DOT_SCRIPT_ROOTDIR}/examples/dotrc" "${dotrc}"
         if [ -e "${dotrc}" ]; then echo "$(grn_ Success.)"; else echo "$(rd_ Failure. Aborted.)"; return 1; fi
      else
         echo "Aborted."; return 1
      fi
   fi

   # open dotrc file
   if [ ! "${dot_edit_default_editor}" = "" ];then
      eval "${dot_edit_default_editor}" "${dotrc}"
   elif hash "$EDITOR"; then
      $EDITOR "${dotrc}"
   else
      xdg-open "${dotrc}"
   fi

   unset -f "$0"
}
