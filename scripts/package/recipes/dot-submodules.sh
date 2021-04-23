#!/usr/bin/env bash
set -euo pipefail

DEFAULT_DOTFILES="${HOME}/dotfiles"

package::is_installed() {
   [[ -f "${DOTFILES}/modules/dotlink/README.md" ]]
}

_default_available() {
   [[ -f "${DEFAULT_DOTFILES}/bin/dot" ]]
}

_symlink() {
   if [ -d "$DEFAULT_DOTFILES" ]; then
      log::warn "Backing up existing dotfiles folder and symlinking new dotfiles..."
      old_dotfiles=$(mktemp -u -d "${DOTFILES}_XXXX")
      mv "$DEFAULT_DOTFILES" "$old_dotfiles"
   fi

   ln -s "$DOTFILES" "$DEFAULT_DOTFILES"
}

package::install() {
   rm -rf "${DOTFILES}/modules/dotlink"
   
   dot pkg add git

   cd "$DOTFILES"

   git submodule init || true
   git submodule update || true
   git submodule foreach git reset --hard || true
   git submodule foreach git checkout . || true
   git submodule foreach git pull origin master || true

   if ! _default_available; then
      _symlink
   fi
}
