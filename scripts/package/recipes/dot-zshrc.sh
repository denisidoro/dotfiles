#!/usr/bin/env bash
set -euo pipefail

ZSHRC_PATH="${DOTFILES}/local/zshrc"

package::is_installed() {
   [ -f "$ZSHRC_PATH" ]
}

_content() {
   echo "#!/usr/bin/env bash"
   echo
   echo "export DOT_FRE=${DOT_FRE:-true}"
   echo "export DOT_DOCOPT=${DOT_DOCOPT:-python}"
}

package::install() {
   dot pkg add dot-folders

   _content > "$ZSHRC_PATH"
   $EDITOR "$ZSHRC_PATH"

   source "$ZSHRC_PATH" || true

   if ${DOT_FRE:-false}; then
      dot pkg add fre || true
   fi

   if [ -n ${DOT_DOCOPT:-} ]; then
      dot pkg add $DOT_DOCOPT
   fi
}
