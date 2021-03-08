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
   echo "export DOT_FRE=${DOT_FRE:-true}"
   echo "export DOT_FZF=${DOT_FZF:-true}"
   echo "export DOT_NAVI=${DOT_NAVI:-true}"
   echo "export DOT_ZIM=${DOT_ZIM:-true}"
   echo "export DOT_THEME=${DOT_THEME:-powerlevel}"
}

package::install() {
   dot pkg add dot-folders

   if ! [ -f "$ZSHRC_PATH" ]; then
      dot pkg add "$EDITOR" || true
      touch "$ZSHRC_PATH"
      _content > "$ZSHRC_PATH"
      $EDITOR "$ZSHRC_PATH"
   fi

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

   if ${DOT_ZIM:-false}; then
      dot pkg add zim
   fi
}
