#!/usr/bin/env bash
set -euo pipefail

ZSHRC_PATH="${DOTFILES}/local/zshrc"

package::is_installed() {
   return 1
}

_content() {
   echo "#!/usr/bin/env bash"
   echo
   echo "export DOT_DOCOPT=\"${DOT_DOCOPT:-python}\""
   echo "export DOT_THEME=${DOT_THEME:-powerlevel}"
   if [ -n "${DOT_ZSHRC_EXTRA:-}" ]; then
      echo
      echo "$DOT_ZSHRC_EXTRA"
   fi
}

package::install() {
   dot pkg add dot-folders || true

   if ! [ -f "$ZSHRC_PATH" ]; then
      dot pkg add "$EDITOR" || true
      touch "$ZSHRC_PATH"
      _content > "$ZSHRC_PATH"
      $EDITOR "$ZSHRC_PATH"
   fi

   # shellcheck disable=SC1090,SC1091
   source "$ZSHRC_PATH" || true

   if [ -n "${DOT_DOCOPT:-}" ]; then
      dot pkg add "$DOT_DOCOPT" || true
   fi

   if ${DOT_NAVI:-false}; then
      dot pkg add navi || true
   fi

   if ${DOT_FRE:-false}; then
      dot pkg add fre || true
   fi

   if ${DOT_FZF:-false}; then
      dot pkg add fzf || true
   fi

   if [ "${DOT_THEME:-}" == "powerlevel" ]; then
      dot pkg add zim-modules || true
   fi 
}
